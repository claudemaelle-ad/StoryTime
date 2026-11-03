# StoryTime

Prototype d'application iOS d'histoires pour enfants, en **Swift** et **SwiftUI**.
L'enfant parcourt une bibliothèque d'histoires, puis les lit page par page, avec une lecture à voix haute.

▶️ **[Voir la vidéo de démonstration](https://drive.google.com/file/d/1UbQjxweShjY6MN0RRvZmIRbKY9fjmYba/view?usp=share_link)**

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-11-03 at 15 10 28" src="https://github.com/user-attachments/assets/b2b4aafc-6068-40da-af76-1a52c696a061" />


## Fonctionnalités

- **Accueil** : mise en avant d'une « histoire du jour » et accès à la bibliothèque
- **Bibliothèque** : grille adaptative (2 colonnes sur iPhone, davantage sur iPad), filtre par catégorie
- **Lecture** : pagination par balayage, barre de progression, boutons précédent / suivant
- **Lecture à voix haute** : voix française de synthèse, un peu ralentie pour les enfants
- Gestion des états de chargement et d'erreur, avec un bouton « Réessayer »
- Une Preview SwiftUI pour chaque écran et chaque composant

## Lancer le projet

**Prérequis** : un Mac avec **Xcode 26** ou plus récent (le projet utilise Swift 6.2).
L'app elle-même fonctionne à partir d'**iOS 17**.

1. Cloner le dépôt, puis ouvrir `StoryTime.xcodeproj`
2. Choisir un simulateur iPhone, puis lancer avec **⌘R**
3. Lancer les tests avec **⌘U**

Aucune dépendance externe : rien à installer.

## Architecture

Pattern **« MV » léger** : des modèles, un store partagé et des vues. Pas de ViewModel par écran, car les écrans affichent des données sans logique métier complexe.

```
Vues (Accueil · Bibliothèque · Lecture)
        │  lisent via @Environment
        ▼
StoryStore (@Observable) ── état partagé : histoires, état de chargement
        │  charge via
        ▼
StoryRepository (protocole)
        ├── BundleStoryRepository → stories.json embarqué
        └── MockStoryRepository   → tests unitaires
```

### Organisation des fichiers

Le code est rangé **par fonctionnalité**, et non par type de fichier.

```
StoryTime/
├── App/              Point d'entrée, NavigationStack et routes
├── Models/           Story, StoryPage, catégories et thèmes
├── Data/             Repository, store et stories.json
├── Services/         Lecture à voix haute (AVSpeechSynthesizer)
├── Features/         Home, Library, Reader
├── Components/       Vues réutilisables (couverture, carte)
└── PreviewSupport/   Données d'exemple pour les Previews
StoryTimeTests/       Tests unitaires (Swift Testing)
```

## Choix techniques

| Choix | Pourquoi |
|---|---|
| **SwiftUI pur, iOS 17 minimum** | Accès au framework Observation (`@Observable`) : plus simple et plus performant que `ObservableObject`. |
| **Contenu dans un fichier JSON** | Le contenu est de la donnée, pas du code : on ajoute une histoire sans toucher au Swift, et le format préfigure celui d'une future API. |
| **Protocole `StoryRepository`** | Les vues ignorent d'où viennent les données. On passe du JSON à une API ou à SwiftData sans modifier l'interface, et on teste le store avec un faux repository. |
| **Navigation par valeur** (`enum Route`) | Un seul `NavigationStack` avec des destinations déclarées à un seul endroit. Les écrans ne se connaissent pas entre eux, ce qui ouvre la voie aux deep links. |
| **Modèles immuables** `Codable`, `Hashable` | Décodage JSON automatique et navigation typée. Des identifiants `String` stables, prêts pour des favoris ou une progression sauvegardée. |
| **Enums pour catégories et thèmes** | Valeurs typées : une catégorie inconnue est rejetée dès le décodage (couvert par un test). |
| **SF Symbols comme illustrations** | Aucun asset à produire pour le prototype. `coverSymbol` deviendra `coverImageURL`. |
| **Synthèse vocale isolée dans `SpeechReader`** | Le lecteur ne dépend pas d'AVFoundation. On pourra remplacer la synthèse par de vrais enregistrements. |
| **Concurrence Swift 6.2** | Isolation `MainActor` par défaut. Les modèles sont `nonisolated` et `Sendable`, et les callbacks du délégué audio reviennent explicitement sur le `MainActor`. |
| **Accessibilité** | Libellés VoiceOver, illustrations décoratives masquées, Dynamic Type respecté. |

## Tests

6 tests unitaires avec **Swift Testing** :
- le store publie les histoires après un chargement réussi ;
- le store passe en état d'erreur si le chargement échoue (grâce au faux repository) ;
- le filtre par catégorie est correct ;
- le fichier `stories.json` embarqué est valide, avec des identifiants uniques ;
- l'illustration d'une page est bien optionnelle ;
- une catégorie inconnue est rejetée au décodage.

## Prochaines étapes

- **Favoris et reprise de lecture**, sauvegardés avec `@AppStorage`, puis SwiftData
- **Vraies illustrations** et **narration audio enregistrée**, avec un mode « lecture automatique »
- **Backend** : une nouvelle implémentation de `StoryRepository` branchée sur une API, avec cache hors ligne
- **Contrôle parental** et filtre par âge
- **Localisation** en plusieurs langues
- **Tests d'interface** (XCUITest) et intégration continue
