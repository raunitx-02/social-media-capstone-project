/* ─────────────────────────────────────────────────────
   SocialSphere DBMS — Frontend Application Logic
───────────────────────────────────────────────────── */

const API = '';

// ── DOM refs ──────────────────────────────────────────
// (db status badge removed from UI)
const toastStack = document.getElementById('toastStack');

// ── Onboarding Modal ───────────────────────────────────
const obBackdrop = document.getElementById('obBackdrop');
const obCta      = document.getElementById('obCta');

function dismissOnboarding() {
    obBackdrop.classList.add('closing');
    obBackdrop.addEventListener('animationend', () => {
        obBackdrop.style.display = 'none';
    }, { once: true });
}

obCta.addEventListener('click', dismissOnboarding);

// Also allow clicking the backdrop itself to dismiss
obBackdrop.addEventListener('click', (e) => {
    if (e.target === obBackdrop) dismissOnboarding();
});


// Explorer
const tableChips   = document.getElementById('tableChips');
const explorerHead = document.getElementById('explorerHead');
const explorerBody = document.getElementById('explorerBody');

// Analytics
const queryCards       = document.querySelectorAll('.qcard');
const runQueryBtn      = document.getElementById('runQueryBtn');
const sqlConsole       = document.getElementById('sqlConsole');
const consoleLabel     = document.getElementById('consoleLabel');
const queryResultSection = document.getElementById('queryResultSection');
const queryResultHead  = document.getElementById('queryResultHead');
const queryResultBody  = document.getElementById('queryResultBody');

// Forms
const userForm       = document.getElementById('userForm');
const postForm       = document.getElementById('postForm');
const insAuthorSelect= document.getElementById('insAuthorSelect');

// Setup
const setupDbBtn = document.getElementById('setupDbBtn');

let activeTableName = null;
let activeQueryCat  = null;

// ══════════════════════════════════════════════════════
// UTILITIES
// ══════════════════════════════════════════════════════

function toast(msg, type = 'info') {
    const el = document.createElement('div');
    const icons = { success: '✓', error: '✗', info: 'ℹ' };
    el.className = `toast ${type}`;
    el.innerHTML = `<span class="toast-icon">${icons[type]}</span><span>${msg}</span>`;
    toastStack.appendChild(el);
    setTimeout(() => {
        el.style.opacity = '0';
        el.style.transform = 'translateX(20px)';
        el.style.transition = 'all 0.3s ease';
        setTimeout(() => el.remove(), 300);
    }, 3500);
}

function renderTable(headEl, bodyEl, rows) {
    if (!rows || rows.length === 0) {
        headEl.innerHTML = '';
        bodyEl.innerHTML = '<tr><td colspan="10" class="empty-state"><div class="empty-icon">🔍</div><p>No records found</p></td></tr>';
        return;
    }
    const cols = Object.keys(rows[0]);
    headEl.innerHTML = '<tr>' + cols.map(c => `<th>${c}</th>`).join('') + '</tr>';
    bodyEl.innerHTML = rows.map(row =>
        '<tr>' + cols.map(c => {
            const v = row[c];
            if (v === null) return `<td><span class="null-badge">NULL</span></td>`;
            const str = String(v);
            const display = str.length > 60 ? str.slice(0, 60) + '…' : str;
            return `<td title="${str.replace(/"/g, '&quot;')}">${display}</td>`;
        }).join('') + '</tr>'
    ).join('');
}

function setLoading(bodyEl, colSpan = 10) {
    bodyEl.innerHTML = `<tr><td colspan="${colSpan}" class="empty-state"><div style="display:flex;align-items:center;gap:10px;justify-content:center"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="animation:spin 1s linear infinite"><line x1="12" y1="2" x2="12" y2="6"/><line x1="12" y1="18" x2="12" y2="22"/><line x1="4.93" y1="4.93" x2="7.76" y2="7.76"/><line x1="16.24" y1="16.24" x2="19.07" y2="19.07"/><line x1="2" y1="12" x2="6" y2="12"/><line x1="18" y1="12" x2="22" y2="12"/><line x1="4.93" y1="19.07" x2="7.76" y2="16.24"/><line x1="16.24" y1="7.76" x2="19.07" y2="4.93"/></svg><span>Querying database…</span></div></td></tr>`;
}

// Inject spin keyframes once
const styleEl = document.createElement('style');
styleEl.textContent = `@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`;
document.head.appendChild(styleEl);

// ══════════════════════════════════════════════════════
// TAB NAVIGATION
// ══════════════════════════════════════════════════════

document.querySelectorAll('.tab').forEach(btn => {
    btn.addEventListener('click', () => {
        const target = btn.dataset.tab;

        document.querySelectorAll('.tab').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));

        btn.classList.add('active');
        const panel = document.getElementById(`panel-${target}`);
        if (panel) panel.classList.add('active');

        if (target === 'actions') loadAuthors();
    });
});

// ══════════════════════════════════════════════════════
// DB STATUS
// ══════════════════════════════════════════════════════

async function checkDbStatus() {
    try {
        const res  = await fetch(`${API}/api/db-status`);
        const data = await res.json();
        return !!data.connected;
    } catch { return false; }
}

// ══════════════════════════════════════════════════════
// TABLE EXPLORER
// ══════════════════════════════════════════════════════

const TABLES = [
    { id: 'users',                 label: 'users' },
    { id: 'user_phones',           label: 'user_phones' },
    { id: 'posts',                 label: 'posts' },
    { id: 'comments',              label: 'comments' },
    { id: 'messages',              label: 'messages' },
    { id: 'user_groups',           label: 'user_groups' },
    { id: 'hashtags',              label: 'hashtags' },
    { id: 'post_hashtags',         label: 'post_hashtags' },
    { id: 'follows',               label: 'follows' },
    { id: 'likes',                 label: 'likes' },
    { id: 'joins',                 label: 'joins' },
    { id: 'user_activity_summary', label: 'user_activity_summary ↗ VIEW' },
];

function buildTableChips() {
    tableChips.innerHTML = '';
    TABLES.forEach(t => {
        const chip = document.createElement('button');
        chip.className = 'chip' + (t.id === activeTableName ? ' active' : '');
        chip.textContent = t.label;
        chip.addEventListener('click', () => {
            activeTableName = t.id;
            document.querySelectorAll('.chip').forEach(c => c.classList.remove('active'));
            chip.classList.add('active');
            fetchTable(t.id);
        });
        tableChips.appendChild(chip);
    });
}

async function fetchTable(name) {
    setLoading(explorerBody);
    explorerHead.innerHTML = '';
    try {
        const res = await fetch(`${API}/api/table/${name}`);
        if (!res.ok) throw new Error((await res.json()).error || res.statusText);
        const rows = await res.json();
        renderTable(explorerHead, explorerBody, rows);
    } catch (err) {
        explorerBody.innerHTML = `<tr><td colspan="10" class="empty-state"><p style="color:var(--red)">Error: ${err.message}</p></td></tr>`;
        toast('Failed to fetch table data', 'error');
    }
}

// ══════════════════════════════════════════════════════
// ANALYTICS — QUERY ENGINE
// ══════════════════════════════════════════════════════

queryCards.forEach(card => {
    card.addEventListener('click', async () => {
        queryCards.forEach(c => c.classList.remove('active'));
        card.classList.add('active');
        activeQueryCat = card.dataset.query;
        runQueryBtn.disabled = false;
        queryResultSection.style.display = 'none';

        sqlConsole.textContent = '-- Loading SQL preview…';
        try {
            const res  = await fetch(`${API}/api/query/${activeQueryCat}`);
            const data = await res.json();
            consoleLabel.textContent = data.description || activeQueryCat;
            sqlConsole.textContent   = data.sql || '-- No SQL returned';
        } catch (err) {
            sqlConsole.textContent = `-- Error loading preview: ${err.message}`;
        }
    });
});

runQueryBtn.addEventListener('click', async () => {
    if (!activeQueryCat) return;
    setLoading(queryResultBody);
    queryResultHead.innerHTML = '';
    queryResultSection.style.display = 'block';

    try {
        const res  = await fetch(`${API}/api/query/${activeQueryCat}`);
        const data = await res.json();
        if (data.error) throw new Error(data.error);
        renderTable(queryResultHead, queryResultBody, data.rows);
        toast(`Query returned ${data.rows.length} rows`, 'success');
    } catch (err) {
        queryResultBody.innerHTML = `<tr><td colspan="10" class="empty-state"><p style="color:var(--red)">Error: ${err.message}</p></td></tr>`;
        toast('Query failed: ' + err.message, 'error');
    }
});

// ══════════════════════════════════════════════════════
// SETUP — DB MIGRATION
// ══════════════════════════════════════════════════════

setupDbBtn.addEventListener('click', async () => {
    setupDbBtn.disabled = true;
    setupDbBtn.textContent = 'Migrating…';
    try {
        const res  = await fetch(`${API}/api/setup-database`, { method: 'POST' });
        const data = await res.json();
        if (data.success) {
            toast('✦ ' + data.message, 'success');
            await checkDbStatus();
            if (activeTableName) fetchTable(activeTableName);
        } else {
            toast('Migration failed: ' + data.error, 'error');
        }
    } catch (err) {
        toast('Error: ' + err.message, 'error');
    } finally {
        setupDbBtn.disabled = false;
        setupDbBtn.textContent = 'Initialize Database';
    }
});

// ══════════════════════════════════════════════════════
// FORMS
// ══════════════════════════════════════════════════════

async function loadAuthors() {
    insAuthorSelect.innerHTML = '<option value="">Loading…</option>';
    try {
        const res   = await fetch(`${API}/api/table/users`);
        const users = await res.json();
        insAuthorSelect.innerHTML = '<option value="">Select author</option>' +
            users.map(u => `<option value="${u.user_id}">${u.username} (ID: ${u.user_id})</option>`).join('');
    } catch {
        insAuthorSelect.innerHTML = '<option value="">Failed to load</option>';
    }
}

userForm.addEventListener('submit', async e => {
    e.preventDefault();
    const btn = userForm.querySelector('.form-submit');
    btn.disabled = true; btn.textContent = 'Writing…';
    try {
        const res  = await fetch(`${API}/api/insert/user`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                username: document.getElementById('insUsername').value,
                email:    document.getElementById('insEmail').value,
                password: document.getElementById('insPassword').value,
                phone:    document.getElementById('insPhone').value,
                dob:      document.getElementById('insDob').value,
                bio:      document.getElementById('insBio').value,
            })
        });
        const data = await res.json();
        if (data.success) { toast(data.message, 'success'); userForm.reset(); }
        else throw new Error(data.error);
    } catch (err) { toast(err.message, 'error'); }
    finally { btn.disabled = false; btn.textContent = 'Write to Database →'; }
});

postForm.addEventListener('submit', async e => {
    e.preventDefault();
    const btn = postForm.querySelector('.form-submit');
    btn.disabled = true; btn.textContent = 'Publishing…';
    try {
        const res  = await fetch(`${API}/api/insert/post`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                user_id:   document.getElementById('insAuthorSelect').value,
                content:   document.getElementById('insPostContent').value,
                media_url: document.getElementById('insMediaUrl').value,
                visibility:document.getElementById('insVisibility').value,
            })
        });
        const data = await res.json();
        if (data.success) { toast(data.message, 'success'); postForm.reset(); }
        else throw new Error(data.error);
    } catch (err) { toast(err.message, 'error'); }
    finally { btn.disabled = false; btn.textContent = 'Publish Post →'; }
});

// ══════════════════════════════════════════════════════
// BOOT
// ══════════════════════════════════════════════════════

(async () => {
    buildTableChips();
    const online = await checkDbStatus();
    if (online) {
        activeTableName = 'users';
        document.querySelector(`.chip[data-table="users"]`)?.classList.add('active');
        // Select first chip
        const firstChip = document.querySelector('.chip');
        if (firstChip) {
            firstChip.classList.add('active');
            activeTableName = TABLES[0].id;
            fetchTable(TABLES[0].id);
        }
    }
})();
