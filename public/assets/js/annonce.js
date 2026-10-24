
(() => {
  'use strict';
  const app = document.querySelector('#app');
  if (!app) return;

  const LOGO = 'assets/images/logo.jpg';
  const FALLBACK = LOGO;
  const API = '/api/annonces.php';
  const CREATE = '/api/ajouter-annonce.php';
  const UPLOAD = '/api/upload-photo.php';
  const CATS = ['Immobilier', 'Véhicules', 'Électronique', 'Mode', 'Maison', 'Services', 'Formation', 'Autres'];
  const ICONS = ['⌂', '♧', '▯', '♧', '⌂', '◇', '▤', '＋'];
  const TITLES = {
    '/': 'Accueil · Tanger', '/categories': 'Catégories · Explorer',
    '/search': 'Recherche · Annonces', '/search/grid': 'Annonces · Grille',
    '/search/list': 'Annonces · Liste', '/search/filters': 'Filtres',
    '/search/sort': 'Tri', '/favorites': 'Favoris', '/messages': 'Messages',
    '/messages/yassine': 'Conversation', '/profile': 'Mon profil',
    '/my-listings/published': 'Mes annonces', '/my-listings/pending': 'Mes annonces',
    '/my-listings/sold': 'Mes annonces', '/notifications': 'Notifications',
    '/settings': 'Paramètres', '/account/login': 'Connexion',
    '/account/register': 'Inscription', '/publish/category': 'Publier',
    '/publish/details': 'Publier', '/publish/photos': 'Photos',
    '/publish/preview': 'Aperçu', '/publish/success': 'Annonce envoyée',
    '/admin/access': 'Modération', '/admin': 'Modération',
    '/onboarding': 'Bienvenue', '/onboarding/discover': 'Découvrir',
    '/onboarding/exchange': 'Échanger', '/onboarding/sell': 'Vendre'
  };

  const pathOf = value => {
    const path = '/' + String(value || '/').replace(/^\/+|\/+$/g, '');
    return path === '/' ? '/' : path;
  };

  function loadFavs() {
    try {
      const value = JSON.parse(localStorage.getItem('chriwbiefavs') || '[]');
      return Array.isArray(value) ? value.map(String) : [];
    } catch (_) { return []; }
  }

  const state = {
    path: pathOf(location.hash.slice(1) || '/'), list: [], loading: true, apiError: '',
    query: '', search: '', sort: 'Les plus récentes',
    filters: { category: '', city: '', min: '', max: '', date: '' },
    favs: loadFavs(),
    form: { category: 'Maison', title: '', price: '', city: '', description: '' },
    photos: [], messages: [], draft: '', busy: false, error: '',
    saved: false, savedPhoto: '', adminError: false
  };

  const esc = value => String(value ?? '').replace(/[&<>"']/g, char => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
  })[char]);

  function src(value) {
    try {
      const url = new URL(value || FALLBACK, location.href);
      return ['https:', 'http:', 'blob:'].includes(url.protocol) ? url.href : FALLBACK;
    } catch (_) { return FALLBACK; }
  }

  const photo = (value, alt = '', cls = '') =>
    `<img class="${esc(cls)}" src="${esc(src(value || LOGO))}" alt="${esc(alt || 'Photo')}" data-fallback="${FALLBACK}">`;
  const btn = (text, path, cls = '') =>
    `<button type="button" class="${esc(cls)}" data-go="${esc(path)}">${text}</button>`;
  const money = value => {
    if (value == null || value === '') return 'Prix à convenir';
    const amount = Number(value);
    return Number.isFinite(amount) ? `${new Intl.NumberFormat('fr-MA').format(amount)} DH` : `${esc(value)} DH`;
  };
  const place = item => [item.ville, item.categorie].filter(Boolean).join(' · ') || 'Maroc';
  const searchBox = (value = state.search, placeholder = 'Que recherchez-vous ?') =>
    `<form class="search-box" id="search-form"><span>⌕</span>
      <input id="search-field" value="${esc(value)}" placeholder="${esc(placeholder)}">
      <button type="button" data-go="/search/filters" aria-label="Filtres">☷</button>
    </form>`;

  function verified() {
    try { return sessionStorage.getItem('chriwbie-admin-verified') === '1'; }
    catch (_) { return false; }
  }

  function goto(path) {
    path = pathOf(path);
    if (path === '/admin' && !verified()) path = '/admin/access';
    if (location.hash !== '#' + path) location.hash = path;
    else { state.path = path; render(); }
    window.scrollTo(0, 0);
  }

  function card(item) {
    const id = String(item.id);
    const favorite = state.favs.includes(id);
    return `<article class="product-card" title="${esc(item.description || '')}">
      <div class="product-photo" data-go="/listing/${encodeURIComponent(id)}">
        ${photo(item.photo, item.titre || 'Photo de l’annonce')}
        <button class="fav" data-fav="${esc(id)}" aria-label="${favorite ? 'Retirer des' : 'Ajouter aux'} favoris">${favorite ? '♥' : '♡'}</button>
      </div>
      <div class="product-copy" data-go="/listing/${encodeURIComponent(id)}" role="link" tabindex="0">
        <b>${esc(item.titre || 'Annonce sans titre')}</b><strong>${money(item.prix)}</strong>
        <small>${esc(place(item))}</small>
      </div>
    </article>`;
  }
  const cards = (items, cls = '') => `<div class="product-grid ${cls}">${items.map(card).join('')}</div>`;

  function top() {
    const title = TITLES[state.path] || (state.path.startsWith('/listing/') ? 'Détail de l’annonce' : 'CHRIWBIE');
    if (state.path === '/admin' || state.path.startsWith('/onboarding')) return '';
    const status = '<div class="status"><span>9:41</span><i></i><span>◉ ▰</span></div>';
    if (state.path === '/') return status + `<header class="home-head">
      <button class="brand" data-go="/">${photo('assets/images/logo.jpg', 'CHRIWBIE')}</button>
      ${btn('♧', '/notifications', 'icon-btn')}
      <button class="avatar-mini" data-go="/profile">${photo('assets/images/avatar-salma.png', 'Profil')}</button>
    </header>`;
    return status + `<header class="page-head">${btn('‹', '/', 'back')}<h1>${esc(title)}</h1>
      ${state.path.startsWith('/publish') ? btn('×', '/', 'icon-btn') : ''}</header>`;
  }

  function nav() {
    return `<nav class="desktop-nav"><button class="wordmark" data-go="/">${photo('assets/images/logo.jpg', 'CHRIWBIE')}</button>
      ${[['Accueil', '/'], ['Catégories', '/categories'], ['Favoris', '/favorites'], ['Messages', '/messages'], ['Mon profil', '/profile']]
        .map(([name, path]) => btn(name, path, state.path === path ? 'is-active' : '')).join('')}
      ${btn('＋ Publier une annonce', '/publish/category', 'desktop-sell')}</nav>
      <nav class="bottom-nav">${[['⌂', 'Accueil', '/'], ['▦', 'Catégories', '/categories'], ['＋', 'Publier', '/publish/category'], ['◯', 'Messages', '/messages'], ['♙', 'Profil', '/profile']]
        .map(([icon, name, path]) => `<button class="${state.path === path ? 'selected' : ''} ${name === 'Publier' ? 'publish-tab' : ''}" data-go="${path}"><span>${icon}</span><small>${name}</small></button>`).join('')}
      </nav>`;
  }

  function waitError() {
    if (state.loading) return '<p class="quiet" role="status">Chargement des annonces…</p>';
    if (state.apiError) return `<div class="callout" role="alert"><b>Les annonces ne sont pas disponibles.</b>
      <p>${esc(state.apiError)}</p><button class="soft-button" data-retry>Réessayer</button></div>`;
    return '';
  }

  function home() {
    let body;
    if (state.loading || state.apiError) body = waitError();
    else if (state.list.length) body = cards(state.list.slice(0, 6), 'compact');
    else body = '<div class="callout"><b>Aucune annonce pour le moment.</b><p>Revenez bientôt découvrir les nouvelles annonces.</p></div>';
    return `<main class="page home-page">${searchBox()}
      <div class="location-row"><span class="place">♧ Tanger, Maroc</span> <span>Annonces récentes</span></div>
      <div class="category-strip">${CATS.slice(0, 5).map((name, i) => `<button data-category="${esc(name)}"><i>${ICONS[i]}</i><small>${esc(name)}</small></button>`).join('')}</div>
      <div class="section-head"><h2>Annonces récentes</h2>${btn('Tout voir', '/search')}</div>${body}
      <div class="callout"><b>Un objet à vendre ?</b><p>Publiez une annonce et partagez-la avec la communauté.</p>
        ${btn('＋ Publier une annonce', '/publish/category', 'soft-button')}</div></main>`;
  }

  function categories() {
    return `<main class="page"><h2 class="serif-heading">Catégories</h2>
      <p class="lead">Trouvez ce qu’il vous faut,<br>près de chez vous.</p>${searchBox(state.search, 'Rechercher une catégorie')}
      <div class="category-grid">${CATS.map((name, i) => {
        const count = state.list.filter(item => (item.categorie || '').toLowerCase() === name.toLowerCase()).length;
        return `<button class="category-tile" data-category="${esc(name)}"><span>${ICONS[i]}</span><b>${esc(name)}</b><small>${count} annonce${count === 1 ? '' : 's'}</small></button>`;
      }).join('')}</div></main>`;
  }

  function parseAmount(value) {
    if (String(value || '').trim() === '') return null;
    const amount = Number(String(value).replace(/[\s,]/g, ''));
    return Number.isFinite(amount) ? amount : null;
  }

  function filtered() {
    let items = [...state.list];
    const query = (state.search || state.query).trim().toLocaleLowerCase('fr');
    if (query) items = items.filter(item => [item.titre, item.description, item.ville, item.categorie]
      .some(value => String(value || '').toLocaleLowerCase('fr').includes(query)));
    if (state.filters.category) items = items.filter(item =>
      (item.categorie || '').toLocaleLowerCase('fr') === state.filters.category.toLocaleLowerCase('fr'));
    if (state.filters.city) items = items.filter(item =>
      String(item.ville || '').toLocaleLowerCase('fr').includes(state.filters.city.toLocaleLowerCase('fr')));
    const min = parseAmount(state.filters.min), max = parseAmount(state.filters.max);
    if (min !== null) items = items.filter(item => Number(item.prix) >= min);
    if (max !== null) items = items.filter(item => Number(item.prix) <= max);
    if (state.filters.date) {
      const cutoff = Date.now() - Number(state.filters.date) * 86400000;
      items = items.filter(item => {
        const date = Date.parse(String(item.date_creation || '').replace(' ', 'T'));
        return Number.isFinite(date) && date >= cutoff;
      });
    }
    const amount = item => Number(item.prix);
    const date = item => Date.parse(String(item.date_creation || '').replace(' ', 'T')) || 0;
    if (state.sort === 'Prix croissant') items.sort((a, b) =>
      (Number.isFinite(amount(a)) ? amount(a) : Infinity) - (Number.isFinite(amount(b)) ? amount(b) : Infinity));
    else if (state.sort === 'Prix décroissant') items.sort((a, b) =>
      (Number.isFinite(amount(b)) ? amount(b) : -Infinity) - (Number.isFinite(amount(a)) ? amount(a) : -Infinity));
    else items.sort((a, b) => date(b) - date(a));
    return items;
  }

  function search() {
    const items = filtered();
    let body;
    if (state.loading || state.apiError) body = waitError();
    else if (items.length) body = cards(items, state.path === '/search/list' ? 'list-view' : '');
    else body = '<div class="callout"><b>Aucune annonce trouvée.</b><p>Modifiez la recherche ou les filtres.</p></div>';
    return `<main class="page search-page">${searchBox(state.search || state.query)}
      <div class="chip-row"><button data-go="/search/filters">☷ Filtres${state.filters.category ? ' · ' + esc(state.filters.category) : ''}</button><button data-clear-search>Effacer</button></div>
      <div class="results-row"><div><b>${state.loading ? '…' : items.length} annonce(s)</b><small>${esc(state.sort)}</small></div>
        <div class="view-tools">${btn('↕', '/search/sort')}${btn('☰', '/search/list', state.path === '/search/list' ? 'view-on' : '')}${btn('▦', '/search/grid', state.path !== '/search/list' ? 'view-on' : '')}</div>
      </div>${body}</main>`;
  }

  function detail() {
    const id = decodeURIComponent(state.path.slice('/listing/'.length));
    const item = state.list.find(entry => String(entry.id) === id);
    if (state.loading) return '<main class="page detail-page"><p class="quiet">Chargement de l’annonce…</p></main>';
    if (!item) return `<main class="page detail-page"><div class="callout"><b>Annonce introuvable.</b>
      <p>Cette annonce ne figure pas dans les données reçues.</p>${btn('Retour aux annonces', '/search', 'primary full')}</div></main>`;
    return `<main class="page detail-page"><div class="hero-image">${photo(item.photo, item.titre || 'Photo de l’annonce')}
      <button class="fav" data-fav="${esc(id)}">${state.favs.includes(id) ? '♥' : '♡'}</button></div>
      <h2>${esc(item.titre || 'Annonce sans titre')}</h2><h3 class="price-lg">${money(item.prix)}</h3>
      <div class="place-line"><span class="place">♧ ${esc(place(item))}</span></div>
      <h3>Description</h3><p class="body-copy">${esc(item.description || 'Aucune description disponible.')}</p>
      <div class="sticky-actions"><button class="primary full" data-go="/account/login">Contacter le vendeur</button></div></main>`;
  }

  function favorites() {
    const items = state.list.filter(item => state.favs.includes(String(item.id)));
    const body = state.loading || state.apiError ? waitError() : items.length ? cards(items) :
      '<div class="callout">♡ Vous n’avez pas encore ajouté d’annonce à vos favoris.</div>';
    return `<main class="page"><h2 class="serif-heading">Favoris</h2>${body}</main>`;
  }
  function myListings() {
    return `<main class="page"><h2 class="serif-heading">Mes annonces</h2><p class="quiet">Aucun compte propriétaire n’est disponible. Les annonces publiques ne peuvent pas être attribuées à un utilisateur.</p>
      <div class="callout">La gestion des annonces personnelles nécessite une authentification et un lien propriétaire côté serveur.</div>${btn('＋ Publier une annonce', '/publish/category', 'primary full')}</main>`;
  }
  function messages() {
    return `<main class="page"><h2 class="serif-heading">Messages</h2><div class="callout"><b>Messagerie de démonstration</b><p>Aucun endpoint de messagerie n’est configuré. Ces échanges restent dans cette session.</p></div>
      ${btn('Ouvrir la maquette de conversation', '/messages/yassine', 'soft-button')}</main>`;
  }
  function conversation() {
    return `<main class="page chat-page"><div class="callout">Conversation de démonstration : aucun message n’est envoyé au serveur.</div>
      ${state.messages.map(message => `<div class="bubble outgoing">${esc(message)}</div>`).join('')}
      <form class="composer" id="message-form"><button type="button">＋</button><input id="message-input" value="${esc(state.draft)}" placeholder="Écrivez votre message…"><button>➤</button></form></main>`;
  }
  function profile() {
    return `<main class="page"><h2 class="serif-heading">Mon profil</h2><div class="profile-card">${photo('assets/images/avatar-salma.png', 'Profil de démonstration')}
      <div><h3>Profil de démonstration</h3><span>Aucun compte utilisateur connecté.</span></div></div>
      <div class="menu-list">${[['♡', 'Favoris', '/favorites'], ['◯', 'Messages', '/messages'], ['＋', 'Publier', '/publish/category'], ['⚙', 'Paramètres', '/settings']]
        .map(([icon, name, path]) => `<button data-go="${path}"><i>${icon}</i><b>${name}</b><span>›</span></button>`).join('')}</div>
      <div class="callout">La création de comptes nécessite un backend d’authentification.</div></main>`;
  }
  function simplePage(title, text) { return `<main class="page"><h2 class="serif-heading">${title}</h2><div class="callout">${text}</div></main>`; }

  function onboarding() {
    const key = state.path.split('/').pop();
    if (state.path === '/onboarding') return `<main class="page onboarding"><div class="onboard-top">${photo('assets/images/logo.jpg', 'CHRIWBIE')} ${btn('Passer', '/')}</div>
      <div class="welcome-logo">${photo('assets/images/logo.jpg', 'CHRIWBIE')}<h2>LE BON COIN, PRÈS DE CHEZ VOUS</h2><p>Trouvez. Vendez. Achetez.</p></div>
      ${btn('→ Découvrir', '/onboarding/discover', 'primary full')}</main>`;
    const slides = {
      discover: ['onboarding-discover.png', 'Les belles trouvailles commencent ici.', 'Découvrez les annonces disponibles.', '/onboarding/exchange'],
      exchange: ['onboarding-exchange.png', 'De bonnes affaires. De belles rencontres.', 'Parcourez les annonces et contactez les vendeurs.', '/onboarding/sell'],
      sell: ['onboarding-sell.png', 'Une seconde vie, un nouveau départ.', 'Publiez une annonce en quelques étapes.', '/']
    };
    const [image, heading, description, next] = slides[key] || slides.discover;
    return `<main class="page onboarding"><div class="onboard-top">${photo('assets/images/logo.jpg', 'CHRIWBIE')} ${btn('Passer', '/')}</div>
      ${photo('assets/images/' + image, heading, 'onboard-image')}<h2 class="serif-heading">${heading}</h2><p>${description}</p>${btn('Continuer', next, 'primary full')}</main>`;
  }

  function account(register) {
    return `<main class="page account-page"><div class="account-logo">${photo('assets/images/logo.jpg', 'CHRIWBIE')}</div><h2>${register ? 'Créer un compte' : 'Connexion'}</h2>
      <p class="quiet">Cette maquette n’est pas reliée à un service de comptes.</p><form id="account-form">
      ${register ? '<label>Nom complet<input required></label>' : ''}<label>Adresse e-mail<input type="email" required></label>
      <label>Mot de passe<input type="password" required></label><button class="primary full">${register ? 'Créer mon compte' : 'Se connecter'}</button></form>
      ${register ? btn('Se connecter', '/account/login', 'inline-link') : btn('Créer un compte', '/account/register', 'inline-link')}</main>`;
  }
  function admin() {
    return '<main class="page admin-page"><div class="admin-heading"><div class="admin-kicker">DÉMONSTRATION</div><h1>Modération des annonces</h1><p>Aucune API de modération n’existe dans le projet.</p></div><div class="callout">La validation et le refus exigent un endpoint serveur et un contrôle d’accès.</div></main>';
  }
  function adminAccess() {
    return `<main class="page account-page"><h2>Modération de démonstration</h2><p class="quiet">L’accès est vérifié localement et n’est pas une authentification sécurisée.</p>
      <form id="admin-access-form"><label>E-mail<input type="email" required></label><label>Mot de passe<input type="password" required></label>
      ${state.adminError ? '<p role="alert">Identifiants incorrects.</p>' : ''}<button class="primary full">Continuer</button></form>${btn('Retour', '/')}</main>`;
  }

  function publish() {
    const step = state.path.split('/').pop();
    if (step === 'success' && !state.saved) {
      setTimeout(() => goto('/publish/preview'), 0);
      return '<main class="page publish-page"><p class="quiet">Vérification…</p></main>';
    }
    if (step === 'success') return `<main class="page success-page"><p class="eyebrow">VOTRE ANNONCE</p><h2>Annonce enregistrée</h2>
      <p class="quiet">L’annonce a été enregistrée dans la base.</p>${photo(state.savedPhoto, state.form.title)}
      <div class="listing-owner"><div><b>${esc(state.form.title)}</b><strong>${money(state.form.price)}</strong><small>${esc(state.form.city)} · ${esc(state.form.category)}</small></div></div>
      ${btn('Voir les annonces', '/search', 'primary full')}${btn('Accueil', '/', 'soft-button full')}</main>`;

    const steps = { category: 0, details: 1, photos: 2, preview: 3 };
    const index = steps[step] ?? 0;
    const headings = ['Que souhaitez-vous vendre ?', 'Décrivez votre annonce.', 'Ajoutez une photo.', 'Vérifiez votre annonce.'];
    let body = '';

    if (index === 0) body = `<p class="quiet">Choisissez une catégorie.</p><div class="category-grid publish-categories">${CATS.map((category, i) =>
      `<button class="category-tile ${state.form.category === category ? 'chosen' : ''}" data-publish-category="${esc(category)}"><span>${ICONS[i]}</span><b>${esc(category)}</b></button>`).join('')}</div>`;
    if (index === 1) body = `<label>Titre<input data-field="title" maxlength="180" value="${esc(state.form.title)}"></label>
      <div class="field-pair"><label>Prix en DH<input type="number" min="0" step="0.01" data-field="price" value="${esc(state.form.price)}"></label>
      <label>Catégorie<select data-field="category">${CATS.map(category => `<option ${state.form.category === category ? 'selected' : ''}>${esc(category)}</option>`).join('')}</select></label></div>
      <label>Ville<input data-field="city" value="${esc(state.form.city)}"></label><label>Description<textarea data-field="description" rows="5">${esc(state.form.description)}</textarea></label>`;
    if (index === 2) body = `<p class="quiet">La première photo sera la couverture ; la base actuelle enregistre une photo par annonce.</p><div class="upload-grid">
      ${state.photos.map((item, i) => `<div class="upload-image">${photo(item.preview, 'Photo choisie')}<button data-remove-photo="${i}">×</button>${i === 0 ? '<small>Couverture</small>' : ''}</div>`).join('')}
      <label class="upload-add">＋<span>Ajouter une photo</span><small>JPG, PNG, WEBP</small><input id="photo-input" type="file" accept="image/jpeg,image/png,image/webp" multiple></label></div>`;
    if (index === 3) body = `<p class="quiet">Aperçu des données qui seront envoyées.</p>${photo(state.photos[0]?.preview, state.form.title, 'preview-image')}
      <h3>${esc(state.form.title || 'Sans titre')}</h3><strong class="price-lg">${money(state.form.price)}</strong><p>${esc(state.form.city)} · ${esc(state.form.category)}</p><p>${esc(state.form.description)}</p>`;
    const next = ['/publish/details', '/publish/photos', '/publish/preview', '/publish/success'][index];
    return `<main class="page publish-page"><div class="progress">${[0, 1, 2, 3].map(i => `<i class="${i <= index ? 'filled' : ''}"></i>`).join('')}</div>
      <small class="eyebrow">ÉTAPE ${index + 1} SUR 4</small><h2>${headings[index]}</h2>${body}
      ${state.error ? `<p class="admin-access-error" role="alert">${esc(state.error)}</p>` : ''}
      <div class="publish-footer"><button class="primary full" ${index === 3 ? `data-submit ${state.busy ? 'disabled' : ''}` : `data-next="${next}"`}>${index === 3 ? (state.busy ? 'Publication en cours…' : 'Publier mon annonce') : 'Continuer'}</button></div></main>`;
  }

  function modal() {
    if (state.path === '/search/filters') return `<div class="scrim" data-dismiss><section class="sheet" role="dialog" aria-modal="true">
      <button class="sheet-close" data-go="/search">×</button><h2>Filtrer les annonces</h2>
      <label>Catégorie<select data-filter="category"><option value="">Toutes les catégories</option>${CATS.map(category => `<option ${state.filters.category === category ? 'selected' : ''}>${esc(category)}</option>`).join('')}</select></label>
      <label>Ville<input data-filter="city" value="${esc(state.filters.city)}" placeholder="Toutes les villes"></label><b>Prix en DH</b>
      <div class="field-pair"><input type="number" data-filter="min" value="${esc(state.filters.min)}" placeholder="Minimum"><input type="number" data-filter="max" value="${esc(state.filters.max)}" placeholder="Maximum"></div>
      <label>Date<select data-filter="date"><option value="">Toutes les dates</option><option value="1" ${state.filters.date === '1' ? 'selected' : ''}>24 dernières heures</option>
      <option value="7" ${state.filters.date === '7' ? 'selected' : ''}>7 derniers jours</option><option value="30" ${state.filters.date === '30' ? 'selected' : ''}>30 derniers jours</option></select></label>
      <button class="primary full" data-apply>Afficher</button><button class="reset" data-reset>Réinitialiser</button></section></div>`;
    if (state.path === '/search/sort') return `<div class="scrim" data-dismiss><section class="sheet"><button class="sheet-close" data-go="/search">×</button><h2>Trier les annonces</h2>
      ${['Les plus récentes', 'Prix croissant', 'Prix décroissant'].map(option => `<button class="sort-option" data-sort="${esc(option)}">${esc(option)}<span>${state.sort === option ? '◉' : '○'}</span></button>`).join('')}</section></div>`;
    return '';
  }

  function content() {
    const path = state.path;
    if (path === '/') return home();
    if (path === '/categories') return categories();
    if (path.startsWith('/search')) return search();
    if (path.startsWith('/listing/')) return detail();
    if (path === '/favorites') return favorites();
    if (path === '/messages') return messages();
    if (path === '/messages/yassine') return conversation();
    if (path === '/profile') return profile();
    if (path.startsWith('/my-listings/')) return myListings();
    if (path === '/notifications') return simplePage('Notifications', 'Aucune API de notifications n’est configurée.');
    if (path === '/settings') return simplePage('Paramètres', 'Aucun compte utilisateur n’est connecté.');
    if (path.startsWith('/publish/')) return publish();
    if (path.startsWith('/onboarding')) return onboarding();
    if (path === '/account/login') return account(false);
    if (path === '/account/register') return account(true);
    if (path === '/admin') return admin();
    if (path === '/admin/access') return adminAccess();
    return `<main class="page"><div class="callout">Page introuvable. ${btn('Accueil', '/')}</div></main>`;
  }

  function render() {
    const noNav = state.path.startsWith('/publish/') || state.path.startsWith('/onboarding') ||
      state.path.startsWith('/account/') || state.path === '/admin' || state.path === '/admin/access' ||
      state.path.startsWith('/listing/');
    app.classList.toggle('admin-mode', state.path === '/admin');
    app.innerHTML = `${nav()}${top()}${content()}${modal()}`;
    const bottom = app.querySelector('.bottom-nav');
    if (bottom) bottom.style.display = noNav ? 'none' : '';
  }

  async function load() {
    state.loading = true;
    state.apiError = '';
    render();
    try {
      const response = await fetch(API, { headers: { Accept: 'application/json' } });
      const contentType = response.headers.get('content-type') || '';
      const body = await response.text();
      let data = null;
      try { if (body.trim()) data = JSON.parse(body); } catch (_) { /* handled below */ }

      if (!response.ok) {
        console.error('API annonces: requête en échec', { status: response.status, contentType, body: body.trim() ? 'non-vide' : 'vide' });
        throw new Error(data && typeof data.error === 'string' ? data.error : `Service annonces indisponible (HTTP ${response.status}).`);
      }
      if (!contentType.toLowerCase().includes('application/json') || !Array.isArray(data) || data.some(item => !item || item.id == null)) {
        console.error('API annonces: réponse inattendue', { status: response.status, contentType, body: body.trim() ? 'non-vide' : 'vide' });
        throw new Error('Réponse invalide du service annonces. Veuillez réessayer plus tard.');
      }

      // Supprime seulement les doublons ayant exactement le même identifiant.
      const uniqueById = new Map();
      data.forEach(item => {
        const id = String(item.id);
        if (!uniqueById.has(id)) uniqueById.set(id, item);
      });
      state.list = Array.from(uniqueById.values());
    } catch (error) {
      console.error('API annonces: chargement impossible', { name: error && error.name || 'Error' });
      state.apiError = error && error.message || 'Réessayez plus tard.';
    } finally {
      state.loading = false;
      render();
    }
  }

  async function upload() {
    if (!state.photos.length) return '';

    const file = state.photos[0].file;
    const allowedTypes = ['image/jpeg', 'image/png', 'image/webp'];
    if (file.size > 5 * 1024 * 1024) throw new Error('La photo doit faire moins de 5 Mo.');
    if (file.type && !allowedTypes.includes(file.type)) throw new Error('Formats acceptés : JPG, PNG et WEBP.');

    const formData = new FormData();
    formData.append('photo', file);
    const response = await fetch(UPLOAD, {
      method: 'POST',
      headers: { Accept: 'application/json' },
      body: formData
    });
    const contentType = response.headers.get('content-type') || '';
    const body = await response.text();
    let data = null;
    try { if (body.trim()) data = JSON.parse(body); } catch (_) { /* handled below */ }

    const statusLabel = 'HTTP ' + response.status + (response.statusText ? ' ' + response.statusText : '');
    const rawMessage = body.trim().replace(/[\r\n\t]+/g, ' ').slice(0, 1200);
    const serverMessage = data && typeof data.error === 'string' && data.error.trim()
      ? data.error.trim()
      : rawMessage;

    if (!contentType.toLowerCase().includes('application/json') || !data || typeof data !== 'object') {
      console.error('API upload photo: réponse non JSON', { status: response.status, contentType, body: rawMessage });
      throw new Error('Échec de l’upload (' + statusLabel + ') : ' + (serverMessage || 'réponse vide ou invalide du serveur.'));
    }
    if (!response.ok || data.success !== true || typeof data.url !== 'string' || !data.url.startsWith('https://')) {
      console.error('API upload photo: téléversement refusé', {
        status: response.status,
        code: typeof data.code === 'string' ? data.code : 'UPLOAD_FAILED',
        error: serverMessage || 'Aucun détail fourni par le serveur.'
      });
      throw new Error('Échec de l’upload (' + statusLabel + ') : ' + (serverMessage || 'Le serveur n’a pas renvoyé d’URL HTTPS valide.'));
    }
    return data.url;
  }
  async function submit() {
    if (state.busy) return;
    if (!state.form.title.trim()) { state.error = 'Le titre est obligatoire.'; render(); return; }
    state.busy = true;
    state.error = '';
    render();
    try {
      const photoUrl = await upload();
      const response = await fetch(CREATE, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify({
          titre: state.form.title.trim(), description: state.form.description.trim(),
          prix: state.form.price, ville: state.form.city.trim(),
          categorie: state.form.category, photo: photoUrl
        })
      });
      const data = await response.json().catch(() => null);
      if (!response.ok || !data || data.success !== true || !data.id) {
        throw new Error(data?.error || `L’API n’a pas confirmé l’enregistrement (HTTP ${response.status}).`);
      }
      state.saved = true;
      state.savedPhoto = photoUrl;
      await load();
      state.path = '/publish/success';
      location.hash = state.path;
      window.scrollTo(0, 0);
    } catch (error) {
      state.error = error.message || 'La publication a échoué.';
    } finally {
      state.busy = false;
      render();
    }
  }

  app.addEventListener('error', event => {
    const target = event.target;
    if (target instanceof HTMLImageElement && target.dataset.fallback &&
        target.src !== new URL(target.dataset.fallback, location.href).href) {
      target.src = new URL(target.dataset.fallback, location.href).href;
    }
  }, true);

  app.addEventListener('click', event => {
    const target = event.target instanceof Element ? event.target : null;
    if (!target) return;
    let element = target.closest('[data-fav]');
    if (element) {
      event.preventDefault(); event.stopPropagation();
      const id = String(element.dataset.fav);
      state.favs = state.favs.includes(id) ? state.favs.filter(value => value !== id) : [...state.favs, id];
      try { localStorage.setItem('chriwbiefavs', JSON.stringify(state.favs)); } catch (_) { /* optional storage */ }
      render(); return;
    }
    element = target.closest('[data-go]');
    if (element) { event.preventDefault(); goto(element.dataset.go); return; }
    element = target.closest('[data-category]');
    if (element) { state.query = element.dataset.category; state.search = ''; goto('/search'); return; }
    element = target.closest('[data-publish-category]');
    if (element) { state.form.category = element.dataset.publishCategory; goto('/publish/details'); return; }
    element = target.closest('[data-sort]');
    if (element) { state.sort = element.dataset.sort; goto('/search'); return; }
    if (target.closest('[data-retry]')) { load(); return; }
    if (target.closest('[data-clear-search]')) {
      state.query = ''; state.search = ''; state.filters = { category: '', city: '', min: '', max: '', date: '' };
      goto('/search'); return;
    }
    if (target.closest('[data-reset]')) {
      state.filters = { category: '', city: '', min: '', max: '', date: '' }; goto('/search'); return;
    }
    if (target.closest('[data-apply]')) { goto('/search'); return; }
    element = target.closest('[data-remove-photo]');
    if (element) { const [removed] = state.photos.splice(Number(element.dataset.removePhoto), 1); if (removed) URL.revokeObjectURL(removed.preview); render(); return; }
    element = target.closest('[data-next]');
    if (element) {
      if (state.path === '/publish/details' && !state.form.title.trim()) { state.error = 'Le titre est obligatoire.'; render(); return; }
      state.error = ''; goto(element.dataset.next); return;
    }
    if (target.closest('[data-submit]')) { submit(); return; }
    if (target.closest('[data-dismiss]') && target === target.closest('[data-dismiss]')) goto('/search');
  });

  app.addEventListener('input', event => {
    const target = event.target;
    if (target.id === 'search-field') state.search = target.value;
    if (target.id === 'message-input') state.draft = target.value;
    if (target.dataset.field) state.form[target.dataset.field] = target.value;
    if (target.dataset.filter) state.filters[target.dataset.filter] = target.value;
  });

  app.addEventListener('change', event => {
    const target = event.target;
    if (target.dataset.field) state.form[target.dataset.field] = target.value;
    if (target.dataset.filter) state.filters[target.dataset.filter] = target.value;
    if (target.id === 'photo-input' && target.files) {
      Array.from(target.files).slice(0, Math.max(0, 8 - state.photos.length)).forEach(file =>
        state.photos.push({ file, preview: URL.createObjectURL(file) }));
      render();
    }
  });

  app.addEventListener('submit', event => {
    const form = event.target;
    if (!(form instanceof HTMLFormElement)) return;
    if (form.id === 'search-form') {
      event.preventDefault(); state.query = state.search.trim(); goto('/search');
    } else if (form.id === 'message-form') {
      event.preventDefault(); if (state.draft.trim()) state.messages.push(state.draft.trim());
      state.draft = ''; render();
    } else if (form.id === 'account-form') {
      event.preventDefault();
    } else if (form.id === 'admin-access-form') {
      event.preventDefault();
      const email = form.querySelector('[type="email"]').value.trim().toLowerCase();
      const password = form.querySelector('[type="password"]').value;
      // Démonstration seulement, pas une authentification sécurisée.
      if (email === 'moderateur@chriwbie.ma' && password === 'Admin2026!') {
        sessionStorage.setItem('chriwbie-admin-verified', '1'); goto('/admin');
      } else { state.adminError = true; render(); }
    }
  });

  window.addEventListener('hashchange', () => {
    let path = pathOf(location.hash.slice(1) || '/');
    if (path === '/admin' && !verified()) { path = '/admin/access'; location.hash = path; }
    state.path = path;
    render();
  });

  render();
  load();
})();
