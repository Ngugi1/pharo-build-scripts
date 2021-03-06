#(TextDiffBuilder RecentMessageList CodeHolder PNGReadWriter FilePackage MCCodeTool MailSender  MailMessage PSMCPatchOperationWrapper ServerDirectory MailAddressParser JPEGReadWriter SoundService  GIFReadWriter ChangeList TTCFont FileContentsBrowser ChangeSorter TTFontReader Morph   SARInstallerZnHTTPSocketFacade MCMethodDefinition MCClassTraitDefinition MCWorkingCopy PackageInfo MCOrganizationDefinition MCTraitDefinition MCClassDefinition) do: [:global |  Object subclass: global  instanceVariableNames: ''  classVariableNames: ''  poolDictionaries: ''  category: 'UNDECLARED'].![ FLPackage initializersEnabled: false.#(World ActiveEvent ActiveWorld ActiveHand) do: [:className |   Smalltalk globals at: className put: nil].FileStream readOnlyFileNamed: 'pharo-core.fuel' do: [:aStream |   aStream binary.  FLPackageLoader new loadFrom: aStream contents readStream].FileStream stdout lf; nextPutAll: 'pharo-core loaded'; lf.#(RGFactory InternetConfiguration NetNameResolver Socket Base64MimeConverter MIMEType UUIDGenerator URI HTTPSocket PackageInfo PackageServices FileServices SystemAnnouncer MCCacheRepository MCDirtyPackageInfo MCEmptyPackageInfo MCMethodDefinition MCMockASubclass MCMockClassA MCMockPackageInfo MCPackageManager MCVersionReader MCWorkingCopy ZnByteEncoder ZnConstants ZnMimeType ZnNetworkingUtils ZnServer ZnSingleThreadedServer) do: [:c | (Smalltalk globals at: c) initialize ].FileStream stdout lf; nextPutAll: 'basic classes initialized'; lf.] ifError: [:e |  | rep |  "FLSerializer serialize: thisContext toFileNamed: 'PharoDebug.fuel'."  rep := FileStream forceNewFileNamed: 'PharoDebug.log'.  rep nextPutAll: 'loadFuel.st'; cr.  rep nextPutAll: 'Error:'; cr.  rep nextPutAll: e asString; cr.  rep nextPutAll: thisContext stack size asString; cr." rep nextPutAll: ((thisContext stack copy at: 12) tempsAndValues ) asString; cr."  thisContext stack copy withIndexDo: [:stck :i |    [rep nextPutAll: i asString; space; nextPutAll: stck asString; cr] ifError: [:er | rep nextPutAll: er asString; cr].    [rep tab; nextPutAll: stck tempsAndValues asString; cr ] ifError: [rep tab; nextPutAll: 'tempsAndValues error...'; cr]].  rep close.   Smalltalk exitFailure.]  !!ScriptLoader methodsFor: 'cleaning' stamp: 'PavelKrivanek 9/23/2010 10:30'!
cleanUpAfterMorphicInitialization
  "self new cleanUpForRelease"

  Author fullName: 'Mr.Cleaner'.
  DebuggerMethodMap withAllSubclassesDo: [ :each | each voidMapCache ].
" self cleanUpPackageOrganizer.
  self cleanUpMethods.
" DataStream initialize.
  GradientFillStyle initPixelRampCache.
  FreeTypeCache clearCurrent.
  ImageMorph classPool at: #DefaultForm put: (Form extent: 1 @ 1 depth: 1).
  Behavior flushObsoleteSubclasses.
  MethodChangeRecord allInstancesDo: [ :x | x noteNewMethod: nil ].
  World cleanseOtherworldlySteppers.
  Smalltalk organization removeEmptyCategories.
  Browser initialize.
  SystemBrowser removeObsolete.
  AppRegistry removeObsolete.
  FileServices removeObsolete.
  MCFileBasedRepository flushAllCaches.
  MCMethodDefinition shutDown. 
  MCDefinition clearInstances.
  Smalltalk globals
    at: #TTFontDescription
    ifPresent: [ :c | 
      c
        clearDefault;
        clearDescriptions ].
  ExternalDropHandler resetRegisteredHandlers.
  Undeclared removeUnreferencedKeys.
  Smalltalk globals flushClassNameCache.
  ScrollBar initializeImagesCache.
  FreeTypeFontProvider current initialize.
  NaturalLanguageTranslator classPool at: #AllKnownPhrases put: nil.
  FreeTypeFontProvider current initialize.
" SystemNavigation default
    allObjectsDo: [ :each | 
      (each respondsTo: #releaseCachedState)
        ifTrue: [ each releaseCachedState ] ].
" 3 timesRepeat: [ 
    Smalltalk garbageCollect.
    Symbol compactSymbolTable ].
  HashedCollection rehashAll.
  
  "Remove empty categories, which are not in MC packages, because MC does
  not do this (this script does not make packages dirty)"
  Smalltalk organization removeEmptyCategories.
  Smalltalk
    allClassesAndTraitsDo: [ :class |
      [ :each |
        each
          removeEmptyCategories;
          sortCategories ]
            value: class organization;
            value: class class organization ].
" PackageOrganizer default packages
    do: [ :each | each methods ifEmpty: [ PackageOrganizer default unregisterPackage: each ] ]
    displayingProgress: 'Cleaning Packages'.
" Smalltalk organization sortCategories.
  ChangeSet removeChangeSetsNamedSuchThat: [ :each | true ].
  ChangeSet resetCurrentToNewUnnamedChangeSet.
  Smalltalk garbageCollect.
  Author reset! !



[
| accuny prj world table |


"accuny := Compiler evaluate: (String fromByteArray: (Base64MimeConverter mimeDecodeToBytes: 
  (FileStream readOnlyFileNamed: (Smalltalk vm getSystemAttribute: 3))) contents) unzipped.
"
accuny := FLMaterializer materializeFromFileNamed: 'dejavu.fuel'. 

TextConstants TextSharedInformation at: #DefaultTextStyle put: accuny.
TextConstants TextSharedInformation at: #'Bitmap DejaVu Sans' put: accuny.
TextConstants TextSharedInformation at: #DefaultMultiStyle put: accuny.
TextConstants TextSharedInformation at: #DefaultFixedTextStyle put: accuny.

"Smalltalk allClasses 
  select: [:class | class sharedPools includes: TextConstants]
  thenDo: [:class | class compileAll. class class compileAll].
"
CommnadLine initialize.

StrikeFontFixer initialize.
TextStyle initialize.

FileStream stdout nextPutAll: 'loading tables...' asString; lf.

Unicode classPool at: #DecimalProperty put: (FLMaterializer materializeFromFileNamed: 'decimalProperty.fuel').
Unicode classPool at: #GeneralCategory put: (FLMaterializer materializeFromFileNamed: 'generalCategory.fuel').
UCSTable classPool at: #GB2312Table put: (FLMaterializer materializeFromFileNamed: 'gb2312Table.fuel').
UCSTable classPool at: #JISX0208Table put: (FLMaterializer materializeFromFileNamed: '#jisX0208Table.fuel').
UCSTable classPool at: #KSX1001Table put: (FLMaterializer materializeFromFileNamed: '#ksx1001Table.fuel').

FileStream stdout nextPutAll: 'finished' asString; lf.

BalloonBezierSimulation initialize.
BalloonEngineConstants initialize.
BalloonEngine initialize.
Browser initialize.
"CommandHistory initialize."
CornerRounder initialize.
CPUWatcher initialize.
Debugger initialize.
DigitalSignatureAlgorithm initialize.
DummySoundSystem initialize.
FileContentsBrowser initialize.
FileList initialize.
FixUnderscores initialize.
FreeTypeCacheConstants initialize.
FreeTypeCache initialize.
"FreeTypeFontProvider initialize."
FreeTypeSettings initialize.
FreeTypeSubPixelAntiAliasedGlyphRenderer initialize.
FT2Constants initialize.
FT2Handle initialize.
GIFReadWriter initialize.
HaloMorph initialize.
HandMorph initialize.
"HostSystemMenus initialize."
ChangeList initialize.
ChangeSorter initialize.
CharacterScanner initialize.
ImageMorph initialize.
JPEGHuffmanTable initialize.
JPEGReadStream initialize.
JPEGReadWriter initialize.
LogicalFont initialize.
LongTestCase initialize.
MailAddressTokenizer initialize.
MailComposition initialize.
MczInstaller initialize.
MD5NonPrimitive initialize.
MenuItemMorph initialize.
MenuMorph initialize.
"MidiPrimTester initialize."
Morph initialize.
MultiCharacterScanner initialize.
"ParagraphEditor initialize."
PNGReadWriter initialize.
PrettyPrinting initialize.
ProcessBrowser initialize.
RealEstateAgent initialize.
"RecentMessageSet initialize."
RxMatcher initialize.
RxParser initialize.
RxsPredicate initialize.
ScriptLoader initialize.
ScrollBar initialize.
SecureHashAlgorithm initialize.
"ServerDirectory initialize."
SHA1 initialize.
ShortIntegerArray initialize.
ShortRunArray initialize.
SimpleEditor initialize.
"StandardToolSet initialize."
StrikeFontFixer initialize.
SystemProgressMorph initialize.
SystemWindow initialize.
TestCase initialize.
TextContainer initialize.
TextDiffBuilder initialize.
"TextPrinter initialize."
ThemeIcons initialize.
ThumbnailMorph initialize.
TransferMorph initialize.
TTCFontDescription initialize.
TTCFontSet initialize.
TTFontDescription initialize.
UITheme initialize.
VistaryThemeIcons initialize.
WorldState initialize.
ZnByteEncoder initialize.
ZnConstants initialize.
ZnMimeType initialize.
ZnNetworkingUtils initialize.
ZnServer initialize.
ZnSingleThreadedServer initialize.
RGFactory initialize.

Cursor initTarget.
Cursor initialize.

DataStream initialize.

BalloonMorph setBalloonColorTo: Color yellow.

"prj := Project new.
Project classPool at: #CurrentProject put: prj.
"
world := PasteUpMorph new.

"prj instVarNamed: #world put: world."
world instVarNamed: #worldState put: WorldState new.

world world addHand: HandMorph new.
world activeHand.

Smalltalk at: #World put: world.
Smalltalk at: #ActiveWorld put: world.
Smalltalk at: #ActiveHand put: world activeHand.
Smalltalk at: #ActiveEvent put: nil.

world viewBox: Display boundingBox.
Sensor flushAllButDandDEvents.
world world handsDo: [:h | h initForEvents].
world borderWidth: 0.

MorphicUIManager new spawnNewProcess.

SystemWindow noteTopWindowIn: world.

Display newDepth: 32.
world displayWorldSafely.

UIManager default: MorphicUIManager new.

world displayWorldSafely.

UIManager default uiProcess resume.

"-----------------MorphicTextEditor register: PluggableTextMorph."

"(Delay forSeconds: 5) wait."


"this classes need world to resetWorldMenu"
SARInstaller initialize.
TTCFont initialize.
TTFontReader initialize.

DiskStore initialize.
Locator initialize.
FileHandle initialize.

"HelpBrowser initialize."
"HostWindowProxy initialize."
LogoImageMorph initialize.
TaskbarMorph initialize.
TextEditor initialize.

"
Gofer it
  squeaksource: 'DejaVu';
  package: 'DejaVuBitmapFonts';
  load.
(Smalltalk globals at: #DejaVuHolder) installFull.
StandardFonts restoreDefaultFonts.
"

PharoTheme beCurrent.


TestRunnerBrowser register: TestRunner.

(world windowsSatisfying: [:w | w model canDiscardEdits]) do: [:w | w delete].


ScriptLoader new cleanUpAfterMorphicInitialization.


Display newDepth: 32.

(world instVarNamed: #worldState) canvas: nil.
SmalltalkEditor initialize.


FreeTypeFontProvider initialize.

SHPreferences initialize.
GraphicFontSettings setFontsToStyleNamed: #small.
CombinedChar loadCompositionMapping.

AbstractFont initialize.
CodeLoader initialize.
DialogItemsChooserUI initialize.
EditorFindReplaceDialogWindow initialize.
FinderUI initialize.
"HelpBrowser initialize."
HostSystemMenus initialize.
HostWindowProxy initialize.
PoolDefiner initialize.
PoolDefiner2 initialize.
RecentMessageList initialize.
SHTextStylerST80 initialize.
UrlCodeFileLoader initialize.

(Smalltalk at: #ActiveHand) instVarNamed: #targetOffset put: 0@0.


"---------LogoImageMorph installDesktopLogo."

PolymorphSystemSettings showDesktopLogo: false.
PolymorphSystemSettings showDesktopLogo: true.
PolymorphSystemSettings desktopColor: Color white.


NOCCompletionTable initialize.
NOCController initialize.
NECController initialize.
NECPreferences initialize.
NECTestSuperClass initialize.
NECTestClass initialize.

Smalltalk cleanOutUndeclared.

AbstractNautilusUI initialize.
BalloonMorph initialize.
DefaultCommandLineHandler initialize.
DefaultExternalDropHandler initialize.
IdentityTransform initialize.
KMPragmaKeymapBuilder initialize.
MCMockRPackage initialize.
MetacelloScriptLoader initialize.
Nautilus initialize.
NautilusIcons initialize.
NautilusMCBindings initialize.
RBAbstractClass initialize.
RBClass initialize.
RBConfigurableFormatter initialize.
RBMacSpellChecker initialize.
RBPharoPlatform initialize.
RBRefactoring initialize.
RBRefactoryChangeManager initialize.
RBScanner initialize.
RBSpellChecker initialize.
RBTransformationRule initialize.
RMockSystemAnnouncer initialize.
RPackage initialize.
RPackageOrganizer initialize.
SpecBinder initialize.
StartupLoader initialize.

#('AST-Core' 'AST-Semantic' 'Announcements-Help' 'Announcements-Tests-Core' 'Announcements-View' 'Balloon' 'BalloonTests' 'CodeImport' 'CodeImport-Tests' 'CollectionsTests' 'Compatibility' 'CompilerTests' 'CompressionTests' 'Deprecated20' 'EmergencyEvaluator' 'EventModel' 'FamFam-Icons' 'FileSystem-Tests-AnsiStreams' 'FileSystem-Tests-Core' 'FileSystem-Tests-Disk' 'FileSystem-Tests-Memory' 'FileSystem-Zip' 'FixUnderscores' 'FreeType' 'FreeTypeTests' 'Gofer-Core' 'Gofer-Tests' 'Graphics-External' 'Graphics-Files' 'Graphics-Fonts' 'Graphics-Resources' 'Graphics-Support' 'Graphics-Tests' 'Graphics-Text' 'GroupManager' 'GroupManagerUI' 'Growl' 'HelpSystem-Core' 'HelpSystem-Tests' 'HistoryCollection' 'KernelTests' 'Keymapping-Core' 'Keymapping-Pragmas' 'Keymapping-Settings' 'Keymapping-Shortcuts' 'Keymapping-Tests' 'Keymapping-Tools-Spec' 'MenuRegistration' 'Monticello' 'MonticelloConfigurations' 'MonticelloGUI' 'Monticellomocks' 'Morphic' 'MorphicTests' 'Multilingual-Tests' 'NECompletion' 'NOCompletion' 'Nautilus' 'NautilusCommon' 'NautilusRefactoring' 'Network-Kernel' 'Network-MIME' 'Network-Mail' 'Network-Protocols' 'Network-RFC822' 'Network-URI' 'Network-UUID' 'Network-Url' 'NetworkTests' 'NonInteractiveTranscript' 'PackageInfo' 'PluggableTextMorphWithLimits' 'Polymorph-EventEnhancements' 'Polymorph-Geometry' 'Polymorph-TaskbarIcons' 'Polymorph-Tools-Diff' 'Polymorph-Widgets' 'RPackage-Core' 'RPackage-SystemIntegration' 'RPackage-Tests' 'RecentSubmissions' 'Refactoring-Changes' 'Refactoring-Core' 'Refactoring-Critics' 'Refactoring-Environment' 'Refactoring-Pharo-Platform' 'Refactoring-Spelling' 'Regex-Core' 'Regex-Help' 'Regex-Tests-Core' 'Ring-Core-Containers' 'Ring-Core-Kernel' 'Ring-Tests-Containers' 'Ring-Tests-Kernel' 'SUnit-Core' 'SUnit-Help' 'SUnit-Tests' 'SUnit-UI' 'ScriptLoader20' 'Settings-Compiler' 'Settings-Display' 'Settings-FreeType' 'Settings-Graphics' 'Settings-Kernel' 'Settings-Monticello' 'Settings-Network' 'Settings-Polymorph' 'Settings-System' 'Settings-Tools' 'Shout' 'ShoutTests' 'Spec-Bindings' 'Spec-Core' 'Spec-Tests' 'Spec-Tools' 'Spec-Widgets' 'StartupPreferences' 'System-Announcements' 'System-Applications' 'System-FilePackage' 'System-Hashing' 'System-History' 'System-Installers' 'System-Serial Port' 'System-Settings' 'System-Sound' 'System-Text' 'System-Tools' 'Tests' 'Tools' 'ToolsTest' 'TrueType' 'UI-Basic' 'Zinc-HTTP' 'Zinc-Patch-HTTPSocket' 'Zinc-Tests') do: [:name | PackageOrganizer default registerPackageNamed: name].
RPackageOrganizer fillUp.

SmalltalkImage current snapshot: true andQuit: false.
SmalltalkImage current snapshot: true andQuit: true.


UIManager default restoreDisplay.

] ifError: [:e |
  | rep |
  rep := FileStream forceNewFileNamed: 'PharoDebug.log'.
  rep nextPutAll: 'info.st'; cr.
  rep nextPutAll: 'Error:'; cr.
  rep nextPutAll: e asString; cr.
  rep nextPutAll: thisContext stack size asString.
  thisContext stack copy withIndexDo: [:stck :i |
    [rep nextPutAll: i asString; space; nextPutAll: stck asString; cr] ifError: []].
  rep close. 
  Smalltalk quitPrimitive] 
