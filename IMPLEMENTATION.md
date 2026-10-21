# CHRIWBIE — écrans livrés

Application web statique en français, construite à partir des exports du ZIP. Les 29 cadres de référence (440 × 956 px) sont conservés dans `design-exports/`. Les découpes photo et le logo original sont dans `assets/images/`.

## Checklist des cadres

- [x] Bienvenue · CHRIWBIE — `#/onboarding`
- [x] Découvrir · Onboarding — `#/onboarding/discover`
- [x] Échanger · Onboarding — `#/onboarding/exchange`
- [x] Vendre · Onboarding — `#/onboarding/sell`
- [x] Accueil · Tanger — `#/`
- [x] Catégories · Explorer — `#/categories`
- [x] Recherche · Maison à Tanger — `#/search`
- [x] Recherche · Filtres — `#/search/filters`
- [x] Recherche · Feuille de tri — `#/search/sort`
- [x] Annonces · Vue grille — `#/search/grid`
- [x] Annonces · Vue liste — `#/search/list`
- [x] Annonce · Canapé en lin beige — `#/listing/sofa`
- [x] Annonce · Contacter Yassine — `#/listing/contact`
- [x] Favoris · Mes coups de cœur — `#/favorites`
- [x] Messages · Boîte de réception — `#/messages`
- [x] Conversation · Yassine et Salma — `#/messages/yassine`
- [x] Profil · Salma Bennani — `#/profile`
- [x] Mes annonces · Publiées — `#/my-listings/published`
- [x] Mes annonces · En attente — `#/my-listings/pending`
- [x] Mes annonces · Vendues — `#/my-listings/sold`
- [x] Notifications · Votre activité — `#/notifications`
- [x] Paramètres · Préférences — `#/settings`
- [x] Compte · Connexion — `#/account/login`
- [x] Compte · Inscription — `#/account/register`
- [x] Publier · Choisir une catégorie — `#/publish/category`
- [x] Publier · Informations de l’annonce — `#/publish/details`
- [x] Publier · Ajouter des photos — `#/publish/photos`
- [x] Publier · Aperçu de l’annonce — `#/publish/preview`
- [x] Publier · Annonce envoyée — `#/publish/success`

## Écran ajouté depuis la nouvelle image

- [x] Validation des annonces (administration) — `#/admin`

Le bouton « Accéder à l’administration » est affiché sur Connexion. L’écran admin reprend les trois demandes, les cartes de compteurs, les filtres, le tableau, les détails et les actions Valider/Refuser de l’image. Les statuts et compteurs sont des données de démonstration en mémoire ; ils se réinitialisent au rechargement. Il n’y a pas d’authentification ni de contrôle d’accès réel dans ce site statique.

## Actions côté navigateur

La navigation, la recherche locale, les catégories, le tri, les filtres, les favoris, le changement de vue, le formulaire de publication, le choix de photos locales, le formulaire de démonstration, la modération, les appels téléphoniques et la saisie de message fonctionnent sans serveur. Les favoris restent dans le stockage local du navigateur. Aucun compte, envoi de message, décision de modération ni publication réelle n’est effectué.

Pour lancer le site : ouvrez `index.html` dans un navigateur, ou utilisez une extension de serveur statique telle que Live Server depuis ce dossier. Le projet n’a pas besoin de compilation ni de paquets externes.

Les images autonomes n’étaient pas incluses dans l’archive ; les photos de meubles, l’illustration d’accueil et les portraits ont donc été découpés dans les cadres fournis. Le logo partagé séparément a été repris comme image d’identité. Aucune référence tablette ou bureau n’était fournie ; les mises en page larges sont des adaptations responsives des écrans mobiles.

## Accès à l’administration

L’écran #/admin/access a été ajouté avant la page de modération. Le bouton sur Connexion ouvre cet écran, et un accès direct à #/admin y est redirigé. Pour la démonstration, utilisez moderateur@chriwbie.ma avec le mot de passe Admin2026!. La vérification est faite uniquement dans le navigateur et n’est pas une authentification sécurisée : un vrai contrôle d’identité nécessite un serveur. Le bouton « Continuer avec mon téléphone » a été retiré de l’interface.
