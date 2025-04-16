# RPG App - Flutter Project

Este é um aplicativo de RPG interativo desenvolvido em Flutter.

## Arquitetura

O aplicativo segue uma arquitetura baseada em componentes, separando responsabilidades em:

-   **Models:** Representam os dados da aplicação (Aventuras, Cenários, Mensagens, etc.).
-   **Views:** Responsáveis pela interface do usuário (Telas Principal, Chat, etc.).
-   **Controllers:** Gerenciam a lógica de negócios e a interação entre Models e Views.
-   **Services:** Encapsulam a lógica de acesso a dados e serviços externos (IA, Backend, etc.).

## Diagramas UML

Abaixo estão os diagramas de classe UML para cada tela principal, representando a arquitetura proposta.

### 1. Main Screen

```mermaid
@startuml

package "Models" {
  class Adventure {
    - id: String // Unique identifier for the adventure
    - scenarioTitle: String // Title of the scenario
    - progress: String // Progress indicator, e.g., "Scene 3" or "50% complete"
  }
  class Scenario {
    - id: String // Unique identifier for the scenario
    - title: String // Title of the scenario
    - genre: String // Genre, e.g., fantasy, sci-fi
    - description: String // Brief description
  }
}

package "Views" {
  class MainScreenView {
    - ongoingAdventures: List<Adventure> // List of ongoing adventures to display
    - scenarios: List<Scenario> // List of available scenarios to display
    + setOngoingAdventures(adventures: List<Adventure>) // Sets the ongoing adventures to display
    + setScenarios(scenarios: List<Scenario>) // Sets the scenarios to display
    + showMessage(message: String) // Shows a message, e.g., "No adventures in progress"
    + onContinueButtonTapped(adventureId: String) // Notifies the controller that the continue button was tapped
    + onStartButtonTapped(scenarioId: String) // Notifies the controller that the start button was tapped
    + onSubscriptionButtonTapped() // Notifies the controller that the subscription button was tapped
    + onInstructionsButtonTapped() // Notifies the controller that the instructions button was tapped
  }
}

package "Services" {
  class AdventureService {
    + getOngoingAdventures(): List<Adventure> // Retrieves the list of ongoing adventures for the user
    + deleteAdventure()
  }
  class ScenarioService {
    + getAvailableScenarios(): List<Scenario> // Retrieves the list of available scenarios
  }
  class BackendService {
    + fetchScenarios(): List<Scenario> // Fetches the latest scenarios from the server
  }
}

package "Controller" {
  class MainScreenController {
    - view: MainScreenView // Reference to the view
    - adventureService: AdventureService // Reference to the adventure service
    - scenarioService: ScenarioService // Reference to the scenario service
    + loadMainScreen() // Loads the main screen by fetching data and updating the view
    + handleContinueAdventure(adventureId: String) // Handles the continue button tap, navigates to chat screen
    + handleStartNewAdventure(scenarioId: String) // Handles the start button tap, navigates to chat screen for new adventure
    + handleSubscriptionTapped() // Handles subscription button tap, navigates to subscription screen
    + handleInstructionsTapped() // Handles instructions button tap, navigates to instructions screen
    + checkFirstLaunch() // Checks if it's the first launch and navigates to instructions if necessary
  }
}

' Relationships
MainScreenView ..> MainScreenController : «uses»
MainScreenController --> MainScreenView
MainScreenController --> AdventureService
MainScreenController --> ScenarioService
MainScreenController --> InstructionsService 
ScenarioService ..> BackendService : «uses»

@enduml
```

### 2. Chat Screen

```mermaid
@startuml

package "Models" {
  class Adventure {
    // Unique identifier for the adventure
    - id: String
    // Identifier of the scenario
    - scenarioId: String
    // List of messages in the chat
    - conversationHistory: Message[*]
    // Current state of the game
    - gameState: GameState
  }

  class Message {
    // Sender of the message, "AI" or "User"
    - sender: String
    // Content of the message
    - content: String
    // Timestamp when the message was sent
    - timestamp: Date
  }

  class GameState {
    // Identifier of the current scene
    - currentScene: String
    // Temporary character data
    - characterData: Map<String, String>
  }
}

package "Views" {
  class ChatScreenView {
    // Sets the messages to display in the chat list
    + setMessages(messages: Message[*])
    // Sets the text in the input field
    + setInputField(text: String)
    // Sets the state of the audio toggle
    + setAudioEnabled(enabled: Boolean)
    // Shows a message, e.g., for errors or notifications
    + showMessage(message: String)
    // Notifies the controller that the send button was tapped with the input text
    + onSendButtonTapped(text: String)
    // Notifies the controller that the dice roll button was tapped
    + onDiceRollButtonTapped()
    // Notifies the controller that the audio toggle was tapped with the new state
    + onAudioToggleTapped(enabled: Boolean)
  }
}

package "Services" {
  class AdventureService {
    // Retrieves an ongoing adventure by its ID
    + getAdventure(adventureId: String): Adventure
    // Creates a new adventure for a given scenario
    + createNewAdventure(scenarioId: String): Adventure
    // Saves the adventure state
    + saveAdventure(adventure: Adventure)
    // Deletes the adventure when it's completed
    + deleteAdventure(adventureId: String)
  }

  class AIService {
    // Generates an AI response based on the current adventure state and user input
    + generateResponse(adventure: Adventure, userInput: String): String
    // Generates a response based on the dice roll result and adventure state
    + generateDiceRollResponse(adventure: Adventure, rollResult: Int): String
  }

  class DiceRollService {
    // Simulates a D20 dice roll and returns the result
    + rollDice(): Int
  }
}

package "Controller" {
  class ChatScreenController {
    // Reference to the view
    - view: ChatScreenView
    // Reference to the adventure service
    - adventureService: AdventureService
    // Reference to the AI service
    - aiService: AIService
    // Reference to the dice roll service
    - diceRollService: DiceRollService
    // The current adventure being played
    - currentAdventure: Adventure
    // Loads the chat screen for an ongoing or new adventure
    + loadChatScreen(adventureId: String?)
    // Handles sending a message from the user
    + handleSendMessage(text: String)
    // Handles the dice roll action
    + handleDiceRoll()
    // Handles the audio toggle action
    + handleAudioToggle(enabled: Boolean)
    // Saves the current adventure state
    + saveAdventure()
  }
}

' Relationships
' Composition relationships
Adventure "1" *-- "0..*" Message : conversationHistory
Adventure "1" *-- "1" GameState : gameState

' Dependencies and associations
ChatScreenView ..> ChatScreenController : «uses»
ChatScreenController --> ChatScreenView
ChatScreenController --> AdventureService
ChatScreenController --> AIService
ChatScreenController --> DiceRollService
ChatScreenController --> Adventure

@enduml
```

### 3. Instructions Screen

```mermaid
@startuml

package "Models" {
  class Instructions {
    - content: String // Contains the instructions text with sci-fi font, neon highlights, and bullet-point formatting
    - isFirstLaunch: Boolean // Flag to detect if it is the first launch of the app
  }
}

package "Views" {
  class InstructionsScreenView {
    - header: String // Displays header text with a back button
    - instructionsText: String // Holds the scrollable instructions content
    - closeButtonLabel: String // Label for the close button
    + setHeader(header: String) // Sets the header text on the view
    + setInstructionsText(text: String) // Sets the instructions content on the view
    + onBackButtonTapped() // Notifies the controller when the back button is tapped
    + onCloseButtonTapped() // Notifies the controller when the close button is tapped
  }
}

package "Services" {
  class InstructionsService {
    + getInstructionsContent(): String // Retrieves the formatted instructions content
    + isFirstLaunch(): Boolean // Checks if the app is launched for the first time
    + setFirstLaunchCompleted(): void // Marks the first launch as completed
  }
}

package "Controller" {
  class InstructionsScreenController {
    - view: InstructionsScreenView // Reference to the instructions screen view
    - instructionsService: InstructionsService // Reference to the instructions service
    + loadInstructionsScreen(): void // Loads the instructions content and updates the view; checks for first launch
    + handleBackAction(): void // Handles the back button action to navigate to the Main Screen
    + handleCloseAction(): void // Handles the close button action to navigate to the Main Screen
  }
}

' Relationships with dependencies and stereotypes
InstructionsScreenView ..> InstructionsScreenController : «uses»
InstructionsScreenController --> InstructionsScreenView
InstructionsScreenController --> InstructionsService : «uses»
InstructionsService ..> Instructions : «references»

@enduml
```

### 4. Rating Screen

```mermaid
@startuml

package "Models" {
  class RatingFeedback {
    - id: String // Unique identifier for the rating feedback
    - adventureId: String // Identifier for the rated adventure
    - userId: String // Identifier for the user providing the feedback
    - overallSatisfaction: int // Overall satisfaction rating (1-5 stars)
    - storyEngagement: int // Story engagement rating (1-5 stars)
    - aiHelpfulness: int // AI helpfulness rating (1-5 stars)
    - additionalComments: String // Optional detailed feedback comments
  }
}

package "Views" {
  class RatingScreenView {
    - header: String // Displays the adventure title
    - overallRating: int // Display value for overall satisfaction stars
    - storyEngagementRating: int // Display value for story engagement stars
    - aiHelpfulnessRating: int // Display value for AI helpfulness stars
    - commentField: String // Contains user input for additional comments
    + setHeader(adventureTitle: String) // Sets the header with the adventure title
    + setRatings(overall: int, storyEngagement: int, aiHelpfulness: int) // Sets the star ratings display
    + setCommentField(text: String) // Sets the text in the comment field
    + showMessage(message: String) // Displays a message to the user (e.g., "Thank you for your feedback!")
    + onStarTapped(category: String, stars: int) // Notifies the controller of a star rating selection
    + onSubmitButtonTapped() // Notifies the controller that the submit button was tapped
  }
}

package "Services" {
  class RatingService {
    + saveFeedback(feedback: RatingFeedback): void // Saves the rating feedback to the cloud for developer analysis
  }
}

package "Controller" {
  class RatingScreenController {
    - view: RatingScreenView // Reference to the rating screen view
    - ratingService: RatingService // Reference to the rating service
    - currentFeedback: RatingFeedback // Holds the current feedback data being collected
    + loadRatingScreen(adventureId: String, adventureTitle: String) // Initializes the rating screen with adventure details
    + handleStarSelection(category: String, stars: int) // Updates the corresponding rating in currentFeedback
    + handleCommentInput(text: String) // Updates additionalComments in currentFeedback
    + handleSubmitFeedback() // Saves feedback and navigates to Main Screen with confirmation message
  }
}

' Relationships with dependencies and stereotypes
RatingScreenView ..> RatingScreenController : «uses»
RatingScreenController --> RatingScreenView
RatingScreenController --> RatingService : «uses»
RatingScreenController --> AdventureService 

@enduml
```

### 5. Subscription Screen

```mermaid
@startuml

package "Models" {
  class SubscriptionPlan {
    - id: String // Unique identifier for the subscription plan
    - name: String // Name of the subscription plan (e.g., "Basic", "Premium")
    - adventureLimit: int // Number of adventures allowed per month
    - price: String // Price for the subscription plan (e.g., "$4.99")
    - details: String // Additional details or description
  }

  class IndividualPurchase {
    - id: String // Unique identifier for the individual purchase option
    - adventuresCount: int // Number of adventures provided (typically 1)
    - price: String // Price for the individual purchase (e.g., "$0.99")
  }

  class SubscriptionStatus {
    - currentPlan: SubscriptionPlan // Current active subscription plan
    - remainingAdventures: int // Remaining adventures for the month
  }
}

package "Views" {
  class SubscriptionScreenView {
    - header: String // Header text with back button
    - tierCards: List<SubscriptionPlan> // List of subscription plan cards to display
    - individualPurchaseOption: IndividualPurchase // Details for individual purchase option
    - status: SubscriptionStatus // Current subscription status details
    + setTierCards(tierCards: List<SubscriptionPlan>) // Sets the subscription plan cards on view
    + setIndividualPurchaseOption(purchase: IndividualPurchase) // Sets the individual purchase option on view
    + setStatus(status: SubscriptionStatus) // Sets the subscription status on view
    + showMessage(message: String) // Displays messages for notifications or errors
    + onSubscribeButtonTapped(planId: String) // Notifies controller when subscribe button is tapped for a plan
    + onBuyNowButtonTapped() // Notifies controller when buy now button is tapped
    + onBackButtonTapped() // Notifies controller when back button is tapped
  }
}

package "Services" {
  class SubscriptionService {
    + getSubscriptionPlans(): List<SubscriptionPlan> // Retrieves available subscription plans
    + getIndividualPurchaseOption(): IndividualPurchase // Retrieves the individual purchase option details
    + getSubscriptionStatus(): SubscriptionStatus // Retrieves the current subscription status for the user
    + processSubscription(planId: String): void // Processes subscription via the Play Store API
    + processIndividualPurchase(): void // Processes individual purchase via in-app billing
  }
}

package "Controller" {
  class SubscriptionScreenController {
    - view: SubscriptionScreenView // Reference to the subscription screen view
    - subscriptionService: SubscriptionService // Reference to the subscription service
    + loadSubscriptionScreen() // Loads the subscription screen by fetching data and updating the view
    + handleSubscribe(planId: String) // Handles subscribe button tap, redirecting to Play Store
    + handleBuyNow() // Handles buy now button tap for individual purchase
    + handleBackNavigation() // Handles back button tap to navigate to the previous screen
  }
}

' Relationships with dependencies and stereotypes
SubscriptionScreenView ..> SubscriptionScreenController : «uses»
SubscriptionScreenController --> SubscriptionScreenView
SubscriptionScreenController --> SubscriptionService : «uses»

@enduml
```

## Backend Simulado (Firebase BaaS)

Para fins de desenvolvimento e teste inicial, o acesso ao backend para buscar cenários (`ScenarioService` e `BackendService`) é **simulado**.

**Como funciona a simulação:**

1.  **Interface:** As classes de serviço (`ScenarioService`, `BackendService`) terão a interface definida como se estivessem interagindo com um BaaS real (Firebase Firestore/Storage).
2.  **Implementação Simulada:** A implementação real dessas classes, no momento, **não** fará chamadas de rede para o Firebase.
3.  **Leitura Local:** Em vez disso, o `BackendService` simulado irá ler arquivos JSON contendo os dados dos cenários diretamente do diretório local `./scenarios/`. Cada arquivo `.json` nesse diretório representará um cenário disponível.

**Objetivo:** Permitir o desenvolvimento e teste da interface e da lógica do aplicativo sem a dependência imediata de um backend Firebase configurado. Futuramente, essa implementação simulada poderá ser substituída pela integração real com o Firebase.

## Próximos Passos (Plano)

1.  **Estrutura do Projeto Flutter:** Criar a estrutura básica de pastas e arquivos do projeto Flutter (`lib`, `assets`, `test`, `pubspec.yaml`, etc.). (Requer mudança para o modo `code`).
2.  **Definição dos Models:** Implementar as classes de modelo (`Adventure`, `Scenario`, `Message`, etc.) em Dart. (Requer mudança para o modo `code`).
3.  **Implementação dos Services:**
    *   Criar as interfaces para `AdventureService`, `ScenarioService`, `BackendService`, `AIService`, `DiceRollService`, `InstructionsService`, `RatingService`, `SubscriptionService`.
    *   Implementar o `BackendService` simulado para ler JSONs da pasta `./scenarios/`.
    *   Implementar o `AIService` para interagir com a API Groq fornecida.
    *   Implementar os demais serviços com lógica básica ou simulada inicialmente. (Requer mudança para o modo `code`).
4.  **Implementação das Views e Controllers:** Desenvolver as telas (Main, Chat, Instructions, Rating, Subscription) e seus respectivos Controllers, conectando-os aos Services. (Requer mudança para o modo `code`).
5.  **Testes:** Escrever testes unitários e de widget. (Requer mudança para o modo `code`).