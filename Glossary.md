# AIDA Beginner Glossary

This glossary explains the important terms used in the AIDA Flutter chatbot
case study. Definitions use plain language, and each use case shows where the
term appears while building AIDA.

**Navigation:** [Back to Case 01](Case-01.md) · [Project README](README.md)

## General development terms

| Term | Simple definition | Use in the AIDA case | More information |
| --- | --- | --- | --- |
| Source code | Human-readable instructions that describe what a program should do. | The Dart files inside `lib` are AIDA's source code. | [Dart language](https://dart.dev/language) |
| SDK | A Software Development Kit is a collection of tools for building applications. | The Flutter SDK provides commands that create, run, test, and build AIDA. | [Flutter SDK archive](https://docs.flutter.dev/install/archive) |
| IDE | An Integrated Development Environment is an application for writing, running, and debugging code. | Android Studio or Visual Studio Code can be used to edit AIDA. | [Flutter editors](https://docs.flutter.dev/tools/editors) |
| Terminal | A text-based window where you type commands for the computer. | You run commands such as `flutter run` and `flutter test` in a terminal. | [Flutter command-line tool](https://docs.flutter.dev/reference/flutter-cli) |
| CLI | A Command-Line Interface is a tool controlled by typed commands. | The Flutter, Dart, Git, ADB, and emulator tools all provide CLIs. | [Flutter CLI reference](https://docs.flutter.dev/reference/flutter-cli) |
| Command | A typed instruction that asks a tool to perform an action. | `flutter pub get` tells Flutter to download AIDA's packages. | [Flutter CLI](https://docs.flutter.dev/reference/flutter-cli) |
| PATH | A system setting that lists folders containing command-line programs. | Adding Flutter to `PATH` allows `flutter` to work from any terminal folder. | [Flutter PATH setup](https://docs.flutter.dev/install/add-to-path) |
| Package | Reusable code created to solve a common problem. | AIDA uses packages for Supabase, HTTP, Markdown, and `.env` loading. | [Dart packages](https://dart.dev/tools/pub/packages) |
| Dependency | A package or library that another project needs in order to work. | The dependencies listed in `pubspec.yaml` are installed before AIDA runs. | [Flutter packages and plugins](https://docs.flutter.dev/packages-and-plugins/using-packages) |
| Version | A number that identifies a particular release of a tool or package. | `flutter --version` shows which Flutter release is installed. | [Flutter SDK releases](https://docs.flutter.dev/release/release-notes) |
| Version control | A system that records file changes so earlier versions can be reviewed or restored. | Git tracks changes made while completing the AIDA case. | [About version control](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control) |
| Git | A version-control tool used to track and share source-code changes. | Students use Git to clone or update the AIDA repository. | [Git documentation](https://git-scm.com/doc) |
| Repository | A project folder whose files and change history are managed by Git. | The AIDA GitHub repository contains the completed project and guide. | [About repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/about-repositories) |
| Clone | To download a complete working copy of a Git repository. | `git clone` starts the Clone-and-Go scaffold. | [Cloning a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) |
| Commit | A saved checkpoint containing a group of file changes. | A learner can commit after completing each major AIDA step. | [Git commits](https://git-scm.com/docs/git-commit) |
| Configuration | Values that control how an application starts or behaves. | AIDA's provider names, URLs, and API keys are configuration values. | [Flutter configuration concepts](https://docs.flutter.dev/deployment/flavors) |
| Environment variable | A named configuration value stored outside normal source-code logic. | `AI_PROVIDER` determines whether AIDA uses Gemini or Groq. | [flutter_dotenv documentation](https://pub.dev/packages/flutter_dotenv) |
| `.env` file | A text file containing environment-variable names and values. | AIDA loads local provider and Supabase configuration from `.env`. | [flutter_dotenv quick start](https://pub.dev/packages/flutter_dotenv#quick-start) |
| `.gitignore` | A file that tells Git which local files it should not track. | AIDA's `.gitignore` prevents `.env` from being uploaded to GitHub. | [Git ignore documentation](https://git-scm.com/docs/gitignore) |
| Build | The process of converting source code and resources into a runnable application. | `flutter build apk` produces an Android installation file for AIDA. | [Flutter build modes](https://docs.flutter.dev/testing/build-modes) |
| Debug mode | A development build that includes tools for inspecting problems and applying quick changes. | `flutter run` normally starts AIDA in debug mode. | [Flutter debug mode](https://docs.flutter.dev/testing/build-modes#debug) |
| Release mode | An optimized build intended for sharing with users. | `flutter build apk` creates a release build by default. | [Flutter release mode](https://docs.flutter.dev/testing/build-modes#release) |

## API, web, and AI terms

| Term | Simple definition | Use in the AIDA case | More information |
| --- | --- | --- | --- |
| API | An Application Programming Interface is a defined way for programs to communicate. | AIDA uses APIs to communicate with Supabase, Gemini, and Groq. | [MDN introduction to web APIs](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Client-side_APIs/Introduction) |
| REST API | A web API organized around URLs and standard HTTP operations. | AIDA sends REST-style HTTP requests to the AI providers. | [REST concepts](https://developer.mozilla.org/en-US/docs/Glossary/REST) |
| Endpoint | The specific web address where an API operation is available. | Groq chat completions use `https://api.groq.com/openai/v1/chat/completions`. | [Groq API reference](https://console.groq.com/docs/api-reference) |
| HTTP | The standard set of rules used to send requests and responses across the web. | AIDA uses the Dart `http` package to contact Gemini and Groq. | [HTTP overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Overview) |
| Request | Data sent by an application to ask a server to perform an operation. | AIDA's request contains the user's question, model name, and settings. | [HTTP messages](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Messages) |
| Response | Data returned by a server after it processes a request. | A Gemini or Groq response contains the assistant's generated text. | [HTTP response messages](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Messages#http_responses) |
| URL | A Uniform Resource Locator is the address of a resource on a network. | The Supabase project URL identifies the AIDA backend. | [What is a URL?](https://developer.mozilla.org/en-US/docs/Learn_web_development/Howto/Web_mechanics/What_is_a_URL) |
| JSON | A text format for organizing data using names, values, lists, and objects. | AIDA encodes AI requests and decodes provider responses as JSON. | [JSON introduction](https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/Scripting/JSON) |
| Header | Extra information attached to an HTTP request or response. | AIDA places content type and authentication values in request headers. | [HTTP headers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers) |
| Content type | A header that describes the format of a request or response body. | AIDA sends `Content-Type: application/json` to both AI providers. | [Content-Type header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Type) |
| API key | A credential that identifies and authorizes an API project. | Gemini and Groq keys allow AIDA to request AI responses. | [Gemini API keys](https://ai.google.dev/gemini-api/docs/api-key) |
| Bearer token | A credential sent after the word `Bearer` in an authorization header. | Groq accepts AIDA's API key as a bearer token. | [Groq quickstart](https://console.groq.com/docs/quickstart) |
| Status code | A number in an HTTP response that reports success or a type of failure. | AIDA treats codes from 200 through 299 as successful API responses. | [HTTP status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status) |
| Timeout | A limit on how long an application waits for an operation. | AIDA stops waiting and shows a friendly message if an AI request takes too long. | [Dart `Future.timeout`](https://api.dart.dev/dart-async/Future/timeout.html) |
| Exception | An object describing a problem that interrupted normal code execution. | AIDA catches network and API exceptions instead of crashing the chat screen. | [Dart error handling](https://dart.dev/language/error-handling) |
| AI | Artificial Intelligence describes computer systems that perform tasks associated with human intelligence. | AIDA uses generative AI to answer learner questions. | [Google AI for Developers](https://ai.google.dev/) |
| Generative AI | AI that creates new content such as text, images, audio, or code. | Gemini and Groq-hosted models generate AIDA's text answers. | [Gemini API overview](https://ai.google.dev/gemini-api/docs) |
| LLM | A Large Language Model is an AI model trained to understand and generate language. | Gemini 3.6 Flash and Llama 3.1 8B are LLMs used by AIDA. | [Gemini models](https://ai.google.dev/gemini-api/docs/models) |
| AI provider | A service that hosts models and exposes APIs for applications. | The `AI_PROVIDER` flag selects Gemini or Groq at startup. | [Gemini API](https://ai.google.dev/gemini-api/docs) |
| Model | A trained AI system selected to perform a task. | AIDA names a particular Gemini or Groq model in each request. | [Groq models](https://console.groq.com/docs/models) |
| Prompt | Text instructions or a question sent to an AI model. | The message typed in AIDA becomes the user's prompt. | [Gemini prompting strategies](https://ai.google.dev/gemini-api/docs/prompting-strategies) |
| System instruction | A high-level direction that defines an AI assistant's role and behavior. | AIDA tells the model to act as a friendly beginner tutor. | [Gemini system instructions](https://ai.google.dev/gemini-api/docs/text-generation#system-instructions) |
| Token | A small unit of text processed by an AI model. | Output-token limits prevent AIDA responses from becoming excessively long. | [Gemini tokens](https://ai.google.dev/gemini-api/docs/tokens) |
| Temperature | A setting that can influence how predictable or varied model output is. | The Groq request uses temperature `0.7` for moderately varied answers. | [Groq text generation](https://console.groq.com/docs/text-chat) |
| Thinking level | A Gemini setting that controls how much reasoning effort the model uses. | AIDA uses `minimal` for quick, straightforward tutoring answers. | [Gemini thinking](https://ai.google.dev/gemini-api/docs/thinking) |
| Model deprecation | A provider announcement that a model will stop being supported. | Learners must replace the Groq model when its shutdown date arrives. | [Groq model deprecations](https://console.groq.com/docs/deprecations) |
| Markdown | Plain text that uses markers for headings, bold text, lists, links, and code. | AIDA renders AI Markdown as readable formatted chat content. | [Markdown basic syntax](https://www.markdownguide.org/basic-syntax/) |

## Flutter and Dart terms

| Term or keyword | Simple definition | Use in the AIDA case | More information |
| --- | --- | --- | --- |
| Flutter | Google's UI toolkit for building applications from one Dart codebase. | Flutter provides AIDA's Android interface and application structure. | [Flutter documentation](https://docs.flutter.dev/) |
| Dart | The programming language used by Flutter applications. | Every file in AIDA's `lib` folder is written in Dart. | [Dart overview](https://dart.dev/overview) |
| Widget | A reusable Flutter description of part of a user interface. | Text fields, buttons, message bubbles, and layouts are widgets. | [Flutter widget overview](https://docs.flutter.dev/ui/widgets-intro) |
| `StatelessWidget` | A widget whose own displayed data does not change after creation. | AIDA uses stateless widgets for individual message bubbles and input layout. | [`StatelessWidget` API](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html) |
| `StatefulWidget` | A widget paired with a State object so its displayed data can change. | `ChatPage` is stateful because messages and loading status change. | [`StatefulWidget` API](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html) |
| `State` | An object that stores changing information for a `StatefulWidget`. | AIDA's chat-page State stores messages, controllers, and `_isLoading`. | [`State` API](https://api.flutter.dev/flutter/widgets/State-class.html) |
| `build` | A method that describes the widgets currently shown on the screen. | AIDA's `build` methods assemble the app, chat page, bubbles, and composer. | [`build` method](https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html) |
| `BuildContext` | A reference to a widget's location inside Flutter's widget tree. | AIDA uses context to read its current theme and colors. | [`BuildContext` API](https://api.flutter.dev/flutter/widgets/BuildContext-class.html) |
| Widget tree | The parent-and-child structure formed by nested Flutter widgets. | AIDA nests a Scaffold, Column, ListView, message bubbles, and input controls. | [Flutter architectural overview](https://docs.flutter.dev/resources/architectural-overview) |
| `MaterialApp` | The top-level widget that configures a Material Design application. | `AidaApp` uses it to set the title, theme, and first screen. | [`MaterialApp` API](https://api.flutter.dev/flutter/material/MaterialApp-class.html) |
| `Scaffold` | A standard Material page structure for an app bar and page body. | The AIDA chat screen places its title and content inside a Scaffold. | [`Scaffold` API](https://api.flutter.dev/flutter/material/Scaffold-class.html) |
| `AppBar` | The horizontal bar normally displayed at the top of a screen. | AIDA's AppBar displays the application name. | [`AppBar` API](https://api.flutter.dev/flutter/material/AppBar-class.html) |
| `SafeArea` | A widget that avoids notches, system bars, and other blocked screen areas. | It keeps AIDA's chat controls visible on different Android phones. | [`SafeArea` API](https://api.flutter.dev/flutter/widgets/SafeArea-class.html) |
| `Row` | A layout widget that arranges children horizontally. | AIDA places the text field and send button in one Row. | [`Row` API](https://api.flutter.dev/flutter/widgets/Row-class.html) |
| `Column` | A layout widget that arranges children vertically. | AIDA stacks the message list, progress bar, and composer in a Column. | [`Column` API](https://api.flutter.dev/flutter/widgets/Column-class.html) |
| `Expanded` | A widget that makes a child fill available space along a Row or Column. | It gives AIDA's message list and input field flexible space. | [`Expanded` API](https://api.flutter.dev/flutter/widgets/Expanded-class.html) |
| `ListView.builder` | A scrolling list that creates visible items when needed. | AIDA builds one message bubble for each chat message. | [`ListView.builder` API](https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html) |
| `TextField` | An input widget where a user can type text. | Learners type questions for AIDA into a TextField. | [`TextField` API](https://api.flutter.dev/flutter/material/TextField-class.html) |
| `TextEditingController` | An object used to read, change, or clear a text field's value. | AIDA reads the typed question and clears it after sending. | [`TextEditingController` API](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html) |
| `setState` | A State method that tells Flutter data changed and the UI should rebuild. | AIDA calls it after adding messages or changing loading status. | [`setState` API](https://api.flutter.dev/flutter/widgets/State/setState.html) |
| `Future` | A Dart object representing a result that will arrive later. | Network and database operations return Futures because they take time. | [Dart asynchronous programming](https://dart.dev/libraries/async/async-await) |
| `async` | A keyword marking a function that performs asynchronous work. | AIDA's send and save methods are asynchronous. | [Dart `async` and `await`](https://dart.dev/libraries/async/async-await) |
| `await` | A keyword that pauses an async function until a Future finishes. | AIDA awaits the AI response before adding it to the message list. | [Dart `async` and `await`](https://dart.dev/libraries/async/async-await) |
| `final` | A keyword declaring a variable that can be assigned only once. | AIDA uses final fields for services, controllers, and calculated values. | [Dart variables](https://dart.dev/language/variables) |
| `const` | A keyword creating a value known and fixed at compile time. | Constant widgets and messages reduce unnecessary object creation. | [Dart constants](https://dart.dev/language/variables#final-and-const) |
| `required` | A keyword making a named argument mandatory. | A message cannot be created without its text and sender information. | [Dart functions and parameters](https://dart.dev/language/functions#named-parameters) |
| `@override` | An annotation showing that a class replaces an inherited method. | AIDA overrides `build`, `dispose`, and service interface methods. | [Dart extending classes](https://dart.dev/language/extend) |
| `mounted` | A State property reporting whether its widget is still in the widget tree. | AIDA checks it before changing UI after a slow network request. | [`mounted` API](https://api.flutter.dev/flutter/widgets/State/mounted.html) |
| `dispose` | A lifecycle method used to release resources when a widget is removed. | AIDA disposes text and scroll controllers and closes HTTP clients. | [`dispose` API](https://api.flutter.dev/flutter/widgets/State/dispose.html) |
| Interface | A contract describing operations a class promises to provide. | `AiService` lets the chat screen work with Gemini, Groq, or a fake test service. | [Dart class modifiers](https://dart.dev/language/class-modifiers) |
| Dependency injection | Providing a class with the services it needs instead of creating them internally. | Tests give AIDA fake AI and repository implementations without real API calls. | [Flutter architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations) |
| `pubspec.yaml` | The main Flutter project file for metadata, dependencies, and assets. | AIDA lists packages and registers `.env` in this file. | [Flutter pubspec](https://docs.flutter.dev/tools/pubspec) |
| Asset | A file bundled with a Flutter application, such as an image or configuration file. | AIDA registers `.env` as an asset so `flutter_dotenv` can load it. | [Flutter assets](https://docs.flutter.dev/ui/assets/assets-and-images) |
| Hot reload | Updating code in a running debug app while mostly preserving its current state. | It quickly previews many AIDA UI edits. | [Flutter hot reload](https://docs.flutter.dev/tools/hot-reload) |
| Hot restart | Restarting the Dart application and losing its current in-memory state. | AIDA needs a restart after changing startup configuration such as `AI_PROVIDER`. | [Flutter hot reload and restart](https://docs.flutter.dev/tools/hot-reload) |
| Widget test | An automated test that builds and interacts with Flutter widgets. | AIDA's widget test types a message, taps Send, and checks the reply. | [Flutter widget testing](https://docs.flutter.dev/testing/overview#widget-tests) |
| Unit test | An automated test of one small function, method, or class. | AIDA tests provider-name parsing without opening the app. | [Flutter unit testing](https://docs.flutter.dev/testing/overview#unit-tests) |

## Supabase and database terms

| Term | Simple definition | Use in the AIDA case | More information |
| --- | --- | --- | --- |
| Database | Organized storage that applications can add to, search, and update. | AIDA stores copies of user and assistant messages in a database. | [Supabase database overview](https://supabase.com/docs/guides/database/overview) |
| Supabase | A backend platform that provides PostgreSQL, authentication, APIs, and other services. | AIDA uses Supabase as its cloud message store. | [Supabase documentation](https://supabase.com/docs) |
| PostgreSQL | The relational database system used by Supabase. | AIDA's `messages` table exists inside PostgreSQL. | [PostgreSQL introduction](https://www.postgresql.org/docs/current/tutorial-start.html) |
| SQL | Structured Query Language is used to create and work with relational databases. | Students run SQL to create AIDA's table, permissions, and RLS policy. | [PostgreSQL SQL tutorial](https://www.postgresql.org/docs/current/tutorial-sql.html) |
| Table | A named database structure containing rows and columns. | The `messages` table stores AIDA conversations. | [PostgreSQL tables](https://www.postgresql.org/docs/current/ddl-basics.html) |
| Row | One complete saved item inside a database table. | Each saved user or assistant message becomes one row. | [Supabase managing data](https://supabase.com/docs/guides/database/tables) |
| Column | A named type of information stored for every table row. | AIDA uses columns such as `sender`, `content`, and `created_at`. | [Supabase tables and columns](https://supabase.com/docs/guides/database/tables) |
| Primary key | A column whose value uniquely identifies each row. | The `id` value distinguishes every saved AIDA message. | [PostgreSQL constraints](https://www.postgresql.org/docs/current/ddl-constraints.html) |
| RLS | Row Level Security uses database policies to control access to individual rows. | AIDA enables RLS before allowing classroom message inserts. | [Supabase Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security) |
| Policy | A database rule that states which operation a role may perform and under what condition. | The tutorial policy lets approved client roles insert valid message rows. | [Supabase RLS policies](https://supabase.com/docs/guides/database/postgres/row-level-security#policies) |
| Publishable key | A Supabase client key designed to identify a public application. | AIDA uses this key to access operations allowed by database policies. | [Supabase API keys](https://supabase.com/docs/guides/api/api-keys) |
| `anon` role | The PostgreSQL role used for a Supabase request from a user who is not signed in. | The classroom app saves messages as `anon` because it has no login screen. | [Supabase roles](https://supabase.com/docs/guides/database/postgres/roles) |
| `authenticated` role | The role used when a Supabase request belongs to a signed-in user. | A future AIDA version with login could give this role per-user access. | [Supabase roles](https://supabase.com/docs/guides/database/postgres/roles) |
| Repository pattern | A design that places data-storage operations behind a small, focused interface. | `ChatRepository` keeps Supabase insert code out of `ChatPage`. | [Flutter architecture guide](https://docs.flutter.dev/app-architecture/guide) |

## Android tools and output terms

| Term | Simple definition | Use in the AIDA case | More information |
| --- | --- | --- | --- |
| Android Studio | Google's development environment for Android applications. | Students install Android SDK tools and manage an AIDA emulator with it. | [Install Android Studio](https://developer.android.com/studio/install) |
| Android SDK | Tools and libraries needed to build applications for Android. | Flutter uses the Android SDK when compiling and installing AIDA. | [Android SDK tools](https://developer.android.com/tools) |
| Gradle | The build system used by Android projects. | Flutter calls Gradle while producing AIDA's Android build. | [Android build overview](https://developer.android.com/build) |
| ADB | Android Debug Bridge is a command-line connection to Android devices. | `adb devices` confirms that an emulator or phone is ready for AIDA. | [ADB documentation](https://developer.android.com/tools/adb) |
| Emulator | Software that behaves like an Android device on a computer. | Students run and test AIDA without needing a physical phone first. | [Android Emulator](https://developer.android.com/studio/run/emulator) |
| AVD | An Android Virtual Device is the saved hardware and Android configuration used by an emulator. | Students create a virtual Pixel-like phone for AIDA testing. | [Manage AVDs](https://developer.android.com/studio/run/managing-avds) |
| Physical device | A real Android phone or tablet connected for testing. | Learners verify AIDA's keyboard, network, size, and performance on real hardware. | [Run on a hardware device](https://developer.android.com/studio/run/device) |
| USB debugging | A Developer options setting that allows ADB to communicate with an Android phone. | It must be enabled before Flutter can install AIDA through USB. | [Configure on-device developer options](https://developer.android.com/studio/debug/dev-options) |
| Android manifest | An XML file declaring essential application information and permissions. | AIDA's manifest declares the internet permission. | [App manifest overview](https://developer.android.com/guide/topics/manifest/manifest-intro) |
| Permission | Approval declared or requested by an app to use a protected device capability. | AIDA declares `android.permission.INTERNET` for API access. | [Android permissions](https://developer.android.com/guide/topics/permissions/overview) |
| Application ID | A unique identifier that distinguishes one Android application from another. | A production AIDA release should replace the default example ID. | [Set the application ID](https://developer.android.com/build/configure-app-module#set-application-id) |
| APK | An Android Package file that can be installed directly on an Android device. | `flutter build apk` creates an installable AIDA file. | [Build an APK with Flutter](https://docs.flutter.dev/deployment/android#build-an-apk) |
| AAB | An Android App Bundle used by Google Play to generate optimized downloads. | A production Play Store release normally uses `flutter build appbundle`. | [Build an app bundle](https://docs.flutter.dev/deployment/android#build-an-app-bundle) |
| Device ID | A name or identifier used by development tools to select a connected target. | `flutter run -d DEVICE_ID` runs AIDA on one chosen phone or emulator. | [Flutter devices command](https://docs.flutter.dev/reference/flutter-cli#flutter-devices) |

---

If a term is still unclear, return to the step where it first appears, read the
code purpose statement, and explain the term using your own AIDA example.
