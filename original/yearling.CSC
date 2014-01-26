' A small text based RPG game.
' Yearlings  by: Colin Bate - RPGenius Software  for v7.0 on 97/06/16
Declare Function mciSendString Lib "winmm.dll" (ByVal lpstrCommand As String, ByVal lpstrReturnString As String, ByVal uReturnLength As Long, ByVal hwndCallback As Long) As Long Alias "mciSendStringA"
Global msReturn As String
Global mlResult As Long
Global iLen As Integer
Global playing As Boolean
DECLARE FUNCTION handle_money(BYVAL how%, BYREF amount%) as BOOLEAN
DECLARE FUNCTION fight_this(BYVAL what$) as BOOLEAN
DECLARE SUB battle(BYVAL ani$)
DECLARE SUB buy(BYVAL num%)
DECLARE SUB buyA(BYVAL nam%)
DECLARE SUB save(BYVAL where%)
DECLARE SUB foundCave(BYVAL how%)
DECLARE SUB saym(txt$)
DECLARE SUB sayt(txxt$)
DECLARE SUB upLevel()
DECLARE SUB youBeatGame()
DECLARE SUB forestYet()
DECLARE SUB enterForest()
DECLARE SUB goInCave()
DECLARE SUB cheat()
DECLARE SUB attack1()
DECLARE SUB run()
DECLARE SUB cure1()
DECLARE SUB bomb1()
DECLARE SUB savegame()
DECLARE SUB weapShop()
DECLARE SUB armShop()
DECLARE SUB genStore()
DECLARE SUB monitor()
DECLARE SUB teller()
DECLARE SUB inn()
DECLARE SUB shop()
DECLARE SUB inTown()
DECLARE SUB prepfight()
DECLARE SUB fight()
DECLARE SUB whereAmI()
GLOBAL o_s as integer
o_s=0
GLOBAL shp as integer
shp=0
GLOBAL chose as integer
chose=0
GLOBAL boss as string
' Boolean stuff
GLOBAL haveP as boolean
GLOBAL haveSR as boolean
GLOBAL haveBR as boolean
GLOBAL odb as boolean
GLOBAL talkFT as boolean
'Other stuff
GLOBAL br as string
br$=""+CHR(13)+""
GLOBAL CONST tMess1$="The evil spirit Kamul haunts the Doomed Woods."
GLOBAL CONST tMess2$="Enemies in the grassland are easier than those in the rocky land."
GLOBAL CONST tMess3$="If I were you, I'd  get to level 13 before even going into the forest."
GLOBAL CONST tMess4$="The Item Shop teller has more than he sells."
GLOBAL CONST tMess5$="I can't find my magical pendant, I think I lost it some where in the field."
GLOBAL genM as string
genM$="1 - Cure potion . . . . . $10"+CHR(13)+"2 - Bomb . . . . . $15"+CHR(13)+"3 - Save your game . . . . . $5"+CHR(13)+"4 - Spend the night . . . . . $35"+CHR(13)+"6 - Leave store"
GLOBAL folder as string
GLOBAL whif as string
GLOBAL saythis as string
GLOBAL max as string
GLOBAL en as string
GLOBAL emon as integer
GLOBAL ehp as integer
GLOBAL eex as integer
GLOBAL disp as string
GLOBAL exfield as integer
GLOBAL exrock as integer
GLOBAL currWeap as string
GLOBAL currArmor as string
GLOBAL money as integer
GLOBAL hp as integer
GLOBAL oldset as integer
GLOBAL maxhp as integer
GLOBAL attack as integer
GLOBAL defence as integer
GLOBAL level as integer
GLOBAL expo as integer
GLOBAL set as integer
set=0
GLOBAL weapAtt as integer
GLOBAL armDef as integer
GLOBAL hePaid as integer
GLOBAL hePaidA as integer
GLOBAL lvl(15) as integer
lvl(1)=90 : lvl(2)=210 : lvl(3)=400 : lvl(4)=630 : lvl(5)=900
lvl(6)=1200 : lvl(7)=1550 : lvl(8)=1950 : lvl(9)=2400 : lvl(10)=2900
lvl(11)=3450 : lvl(12)=4050 : lvl(13)=4700 : lvl(14)=5400 : lvl(15)=6200
GLOBAL weaponList(5) as string
GLOBAL armorList(5) as string
GLOBAL itemList(4) as string
GLOBAL enemies(10) as string
GLOBAL title(5) as string
GLOBAL weap(5) as string
GLOBAL arm(5) as string
GLOBAL price(5) as integer
GLOBAL addon(5) as integer
GLOBAL cure as integer
GLOBAL bomb as integer
GLOBAL oldSw as string
GLOBAL cantRun as boolean
GLOBAL code as string
weaponList(1)="Rapier;150:3"
weaponList(2)="Phantom Blade;300:7"
weaponList(3)="Katana;550:10"
weaponList(4)="eXaliber;800:15"
weaponList(5)="Masemune;1150:21"
armorList(1)="Aura Coat;200:2"
armorList(2)="Chain Mail;300:5"
armorList(3)="Plate Mail;450:9"
armorList(4)="Dragon Torso;600:13"
armorList(5)="Diamond Suit;800:18"
#ADDRESBMP Year "year.bmp"
#DEFINE welcome hubba%=MESSAGEBOX("I'm glad you chose to play Yearlings from RPGenius Software. Even though this game is freeware, if you can find it in your heart to send me $5 or $10 for all my hard work on this game, then please do so.", "Welcome to Yearlings", 0 OR 0)
#DEFINE start sayt("Grassland") : saym("The mist settles and you find yourself in a grassy field. There is a town nearby. The field is bordered on the West by a dense forest. There seems to be a powerful negative aura given off by the forest. You decide to stay out of the forest for the time being. To the East is a barren rocky area. This is some strange terrain, you think to yourself."+CHR(13)+"--------------------------"+CHR(13)+"1 - Explore the field"+CHR(13)+"2 - Enter the town"+CHR(13)+"3 - Explore the rocky area")
#DEFINE nothingInF sayt("Grassland") : saym("1 - Continue exploring the field"+CHR(13)+"2 - Enter the town"+CHR(13)+"3 - Explore the rocky area") : set=0 : forestYet
#DEFINE nothingInR sayt("Rocky Land") : saym("1 - Explore the field"+CHR(13)+"2 - Enter the town"+CHR(13)+"3 - Continue exploring the rocky area") : set=4 : forestYet
#DEFINE outOfTown sayt("Grassland") : saym("1 - Explore the field"+CHR(13)+"2 - Enter the town"+CHR(13)+"3 - Explore the rocky area") : set=0 : forestYet
#DEFINE foundPend saym("You found a pendant in the grass!"+CHR(13)+CHR(13)+"1 - Pick it up"+CHR(13)+"2 - Leave it") : haveP=TRUE
#DEFINE foundRope saym("You found a rope tangled in a tree!"+CHR(13)+CHR(13)+"1 - Take it"+CHR(13)+"2 - Leave it") : haveSR=TRUE
#DEFINE trade sayt("Item Shop") : saym("As you walk into the item shop the man behind the counter sees your rope and asks what it's for. After telling him he laughs and says "+CHR(34)+"Why that old rope wouldn't 'old nobody. You'se lucky dat I got me a new rope here, 'ave it!"+CHR(34)+" You take the rope from the man.") : haveBR=TRUE : haveSR=FALSE
#DEFINE GoodBye fits%=MESSAGEBOX("Thank You for playing 'Yearlings'"+CHR(13), "© RPGenius Software", 0 OR 48) : game.CLOSEDIALOG 3
BEGIN DIALOG OBJECT game 291, 255, "Yearlings v1.1", SUB year
	STATUS .status
	GROUPBOX  84, 1, 122, 24, .GroupBox1
	TEXT  53, 37, 186, 9, .title, ""
	TEXT  43, 54, 204, 107, .main, ""
	PUSHBUTTON  13, 177, 35, 18, .one, "&1"
	PUSHBUTTON  59, 177, 35, 18, .two, "&2"
	PUSHBUTTON  105, 177, 35, 18, .three, "&3"
	PUSHBUTTON  151, 177, 35, 18, .four, "&4"
	PUSHBUTTON  197, 177, 35, 18, .five, "&5"
	PUSHBUTTON  244, 177, 35, 18, .six, "&6"
	IMAGE  89, 8, 112, 13, .bmp
	PUSHBUTTON  52, 208, 46, 18, .PushButton7, "&New"
	PUSHBUTTON  123, 208, 46, 18, .PushButton8, "&Open"
	PUSHBUTTON  194, 208, 46, 18, .PushButton9, "&Exit"
END DIALOG
game.SETSTYLE 32
game.title.SETSTYLE 256
game.title.SETSTYLE 64
game.main.SETSTYLE 8
game.bmp.SETIMAGE "#Year"
game.bmp.SETSTYLE 32
game.status.SETTEXT "Copyright © 1997 RPGenius Software. All rights reserved."
BEGIN DIALOG OBJECT os 241, 143, "", SUB openSave
	TEXT  9, 9, 32, 8, .Text2, "Game #1:"
	TEXT  9, 30, 32, 8, .Text3, "Game #2:"
	TEXT  9, 52, 32, 8, .Text4, "Game #3:"
	TEXT  9, 74, 32, 8, .Text5, "Game #4:"
	TEXT  9, 96, 32, 8, .Text6, "Game #5:"
	PUSHBUTTON  43, 116, 65, 17, .o_s, ""
	CANCELBUTTON  132, 116, 65, 17, .Cancel1
	TEXTBOX  45, 7, 133, 13, .g1
	TEXTBOX  45, 28, 133, 13, .g2
	TEXTBOX  45, 50, 133, 13, .g3
	TEXTBOX  45, 72, 133, 13, .g4
	TEXTBOX  45, 94, 133, 13, .g5
	PUSHBUTTON  193, 6, 36, 15, .b1, "<---"
	PUSHBUTTON  193, 28, 36, 15, .b2, "<---"
	PUSHBUTTON  193, 49, 36, 15, .b3, "<---"
	PUSHBUTTON  193, 71, 36, 15, .b4, "<---"
	PUSHBUTTON  193, 93, 36, 15, .b5, "<---"
END DIALOG
cheat
retvb%=DIALOG(game)
IF retvb%=2 THEN GoodBye
SUB year(BYVAL ControlID%, BYVAL Event%)
	IF Event=0 THEN
		game.one.ENABLE 0
		game.two.ENABLE 0
		game.three.ENABLE 0
		game.four.ENABLE 0
		game.five.ENABLE 0
		game.six.ENABLE 0
	ENDIF
	'Exit Button
	IF Event=2 AND ControlID=14 THEN
		reee%=MESSAGEBOX("Exit? Are you sure?", "QUIT", 4 OR 32)
		IF reee=6 THEN GoodBye
	ENDIF
	' New game
	IF Event=2 AND ControlID=12 THEN
		set=0
		currWeap="(none)"
		currArmor="(none)"
		money=150
		hp=30
		maxhp=30
		attack=4
		defence=3
		level=1
		expo=0
		hePaid=0
		hePaidA=0
		weapAtt=0
		armDef=0
		cure=0
		bomb=0
		haveP=FALSE
		haveSR=FALSE
		haveBR=FALSE
		talkFT=FALSE
		odb=FALSE
		game.one.SETSTYLE 1
		game.two.SETSTYLE 1
		game.three.SETSTYLE 1
		game.four.SETSTYLE 1
		game.five.SETSTYLE 1
		game.six.SETSTYLE 1
		game.one.ENABLE -1
		game.two.ENABLE -1
		game.three.ENABLE -1
		welcome
		start
	ENDIF
	' Open button
	IF Event=2 AND ControlID=13 THEN
		o_s=0
		folder$=GETFOLDER()
		IF folder<>"" THEN
			SETCURRFOLDER folder
			os.SETTEXT "Open game - ["+folder+"]"
			os.o_s.SETTEXT "Open"
			succ%=DIALOG(os)
			IF succ%<>2 THEN
				game.one.SETSTYLE 1
				game.two.SETSTYLE 1
				game.three.SETSTYLE 1
				game.four.SETSTYLE 1
				game.five.SETSTYLE 1
				game.six.SETSTYLE 1
			ENDIF
		ENDIF
	ENDIF
	' Button 1
	IF Event=2 AND ControlID=5 THEN
		IF set=0 THEN
			prepfight
		ELSEIF set=1 THEN
			weapShop
		ELSEIF set=2 AND shp=1 THEN
			IF hePaid>=price(1) THEN
				yop%=MESSAGEBOX("Replace your "+currWeap+"?", "Weapon Shop", 4 OR 32)
				IF yop=6 THEN buy(1)
			ELSE
			buy(1)
			ENDIF
		ELSEIF set=2 AND shp=2 THEN
			IF hePaidA>=price(1) THEN
				yop%=MESSAGEBOX("Replace your "+currArmor+"?", "Armour Shop", 4 OR 32)
				IF yop=6 THEN buyA(1)
			ELSE
			buyA(1)
			ENDIF
		ELSEIF set=2 AND shp=3 THEN
			blah=handle_money(0, 10)
			IF blah=TRUE THEN
				IF cure<20 THEN
					cure=cure+1
					saym(genM+CHR(13)+CHR(13)+"Thank you!")
				ELSE
					saym(genM+CHR(13)+CHR(13)+"You can't carry anymore cure potions!")
				ENDIF
			ELSE
				saym(genM+CHR(13)+CHR(13)+"Sorry, you don't have enough money")
			ENDIF
		ELSEIF set=4 THEN
			set=0
			exrock=0
			prepfight
		ELSEIF set=6 THEN
			haveP=TRUE
			nothingInF
			game.three.ENABLE -1
		ELSEIF set=7 THEN
			haveSR=TRUE
			nothingInF
			game.three.ENABLE -1
		ELSEIF set=9 THEN
			goInCave
		ELSEIF set=10 THEN
			attack1
		ELSEIF set=11 THEN
			IF oldset=0 AND exfield=4 AND haveP=FALSE THEN
				exfield=0
				set=6
				foundPend
				game.one.ENABLE -1
				game.two.ENABLE -1
				game.three.ENABLE 0
				game.four.ENABLE 0
				game.five.ENABLE 0
				game.six.ENABLE 0
			ELSEIF oldset=0 AND exfield=5 AND haveP AND talkFT AND haveBR=FALSE THEN
				foundRope
				set=7
				game.one.ENABLE -1
				game.two.ENABLE -1
				game.three.ENABLE 0
				game.four.ENABLE 0
				game.five.ENABLE 0
				game.six.ENABLE 0
			ELSEIF oldset=0 THEN
				nothingInF
				set=0
				game.two.ENABLE -1
				game.three.ENABLE -1
			ELSEIF oldset=4 AND exrock=5 AND talkFT AND odb=FALSE AND haveSR=FALSE AND haveBR=FALSE THEN
				foundCave(0)
			ELSEIF oldset=4 AND exrock=5 AND haveSR AND odb=FALSE AND haveBR=FALSE THEN
				foundCave(1)
			ELSEIF oldset=4 AND exrock=5 AND odb=FALSE AND haveBR THEN
				foundCave(1)
			ELSE
				nothingInR
				set=4
				game.two.ENABLE -1
				game.three.ENABLE -1
			ENDIF
		ENDIF
	ENDIF
	' Button 2
	IF Event=2 AND ControlID=6 THEN
		IF set=0 THEN
			inTown
		ELSEIF set=1 THEN
			armShop
		ELSEIF set=2 AND shp=1 THEN
			IF hePaid>=price(2) THEN
				yop%=MESSAGEBOX("Replace your "+currWeap+"?", "Weapon Shop", 4 OR 32)
				IF yop=6 THEN buy(2)
			ELSE
			buy(2)
			ENDIF
		ELSEIF set=2 AND shp=2 THEN
			IF hePaidA>=price(2) THEN
				yop%=MESSAGEBOX("Replace your "+currArmor+"?", "Armour Shop", 4 OR 32)
				IF yop=6 THEN buyA(2)
			ELSE
			buyA(2)
			ENDIF
		ELSEIF set=2 AND shp=3 THEN
			blah=handle_money(0, 15)
			IF blah=TRUE THEN
				IF bomb<20 THEN
					bomb=bomb+1
					saym(genM+CHR(13)+CHR(13)+"Thank you!") 
				ELSE
					saym(genM+CHR(13)+CHR(13)+"You can't carry anymore bombs!")
				ENDIF
			ELSE
				saym(genM+CHR(13)+CHR(13)+"Sorry, you don't have enough money")
			ENDIF
		ELSEIF set=4 THEN
			inTown
		ELSEIF set=6 THEN
			nothingInF
			game.three.ENABLE -1
		ELSEIF set=7 THEN
			nothingInF
			game.three.ENABLE -1
		ELSEIF set=9 THEN
			nothingInR
			game.three.ENABLE -1
		ELSEIF set=10 THEN
			bomb1
		ENDIF
	ENDIF
	' Button 3
	IF Event=2 AND ControlID=7 THEN
		IF set=0 THEN
			set=4
			exfield=0
			prepfight
		ELSEIF set=1 THEN
			genStore
		ELSEIF set=2 AND shp=1 THEN
			IF hePaid>=price(3) THEN
				yop%=MESSAGEBOX("Replace your "+currWeap+"?", "Weapon Shop", 4 OR 32)
				IF yop=6 THEN buy(3)
			ELSE
			buy(3)
			ENDIF
		ELSEIF set=2 AND shp=2 THEN
			IF hePaidA>=price(3) THEN
				yop%=MESSAGEBOX("Replace your "+currArmor+"?", "Armour Shop", 4 OR 32)
				IF yop=6 THEN buyA(3)
			ELSE
			buyA(3)
			ENDIF
		ELSEIF set=2 AND shp=3 THEN
			blah=handle_money(0, 5)
			IF blah=TRUE THEN savegame ELSE saym(genM+CHR(13)+CHR(13)+"Sorry, you don't have enough money")
		ELSEIF set=4 THEN
			prepfight
		ELSEIF set=10 THEN
			cure1
		ENDIF
	ENDIF
	' Button 4
	IF Event=2 AND ControlID=8 THEN
		IF set=0 THEN
			enterForest
		ELSEIF set=1 THEN
			monitor
		ELSEIF set=2 AND shp=1 THEN
			IF hePaid>=price(4) THEN
				yop%=MESSAGEBOX("Replace your "+currWeap+"?", "Weapon Shop", 4 OR 32)
				IF yop=6 THEN buy(4)
			ELSE
			buy(4)
			ENDIF
		ELSEIF set=2 AND shp=2 THEN
			IF hePaidA>=price(4) THEN
				yop%=MESSAGEBOX("Replace your "+currArmor+"?", "Armour Shop", 4 OR 32)
				IF yop=6 THEN buyA(4)
			ELSE
			buyA(4)
			ENDIF
		ELSEIF set=2 AND shp=3 THEN
			blah=handle_money(0, 35)
			IF blah=TRUE THEN hp=maxhp : saym(genM+CHR(13)+CHR(13)+"There you go!") ELSE saym(genM+CHR(13)+CHR(13)+"Sorry, you don't have enough money")
		ELSEIF set=4 THEN
			enterForest
		ELSEIF set=10 THEN
			run
		ENDIF
	ENDIF
	' Button 5
	IF Event=2 AND ControlID=9 THEN
		IF set=1 THEN
			teller
		ELSEIF set=2 AND shp=1 THEN
			IF hePaid>=price(5) THEN
				yop%=MESSAGEBOX("Replace your "+currWeap+"?", "Weapon Shop", 4 OR 32)
				IF yop=6 THEN buy(5)
			ELSE
			buy(5)
			ENDIF
		ELSEIF set=2 AND shp=2 THEN
			IF hePaidA>=price(5) THEN
				yop%=MESSAGEBOX("Replace your "+currArmor+"?", "Armour Shop", 4 OR 32)
				IF yop=6 THEN buyA(5)
			ELSE
			buyA(5)
			ENDIF
		ENDIF
	ENDIF
	' Button 6
	IF Event=2 AND ControlID=10 THEN
		IF set=1 THEN
			set=0
			whereAmI
		ELSEIF set=2 THEN
			inTown
		ENDIF
	ENDIF
END SUB
SUB saym(txt$)
	game.main.SETTEXT txt
END SUB
SUB sayt(txxt$)
	game.title.SETTEXT txxt
END SUB
SUB inTown()
	exfield=0
	exrock=0
	game.one.ENABLE -1
	game.two.ENABLE -1
	game.three.ENABLE -1
	game.four.ENABLE -1
	game.five.ENABLE -1
	game.six.ENABLE -1
	set=1
	sayt("Town of Pylaim")
	saym("You take a look around the town. You see weapon and armour shops plus a general store. On the other side of town you see a monitor station and a fortune tellers tent."+CHR(13)+"-------------------------"+CHR(13)+\\
	"1 - Weapon Shop"+CHR(13)+"2 - Armour Shop"+CHR(13)+"3 - General Store"+CHR(13)+"4 - Monitor Station"+CHR(13)+"5 - Fortune Teller"+CHR(13)+"6 - Leave town")
END SUB
SUB prepfight()
	IF set=0 THEN
		OPEN "grass.eny" FOR INPUT AS 1
		FOR a%=1 TO 10
			LINE INPUT #1, enemies(a)
		NEXT a
		CLOSE 1
	ELSEIF set=4 THEN
		OPEN "rocky.eny" FOR INPUT AS 1
		FOR a%=1 TO 10
			LINE INPUT #1, enemies(a)
		NEXT a
		CLOSE 1
	ENDIF
	game.one.ENABLE -1
	game.two.ENABLE -1
	game.three.ENABLE -1
	game.four.ENABLE -1
	game.five.ENABLE 0
	game.six.ENABLE 0
	fight
END SUB
SUB fight()
	RANDOMIZE
	lower = 1
	upper = 10
	a_random = INT((upper - lower +1)*RND()+lower)
	IF a_random<1 THEN a_random=a_random+10
	jim=enemies(a_random)
	IF boss="morlin" THEN jim="Morlin-110;10:200"
	IF boss="kamul" THEN jim="Kamul-180;0:0"
	en$=LEFT(jim, INSTR(jim, "-")-1)
	ehp%=VAL(LEFT(MID(jim, INSTR(jim, "-")+1), INSTR(MID(jim, INSTR(jim, "-")+1), ";")-1))
	emon%=VAL(LEFT(MID(jim, INSTR(jim, ";")+1), INSTR(MID(jim, INSTR(jim, ";")+1), ":")-1))
	eex%=VAL(RIGHT(jim, LEN(jim)-INSTR(jim, ":")))
	IF boss<>"" THEN GOTO fBoss
	IF fight_this(en) THEN
		IF set=0 THEN exfield=exfield+1 : oldset=0
		IF set=4 THEN exrock=exrock+1 : oldset=4
		max$=CSTR(ehp)
		whif=""
		battle(en)
	ELSE
		game.four.ENABLE 0
		IF set=0 THEN
			exfield=0
			nothingInF
		ELSEIF set=4 THEN
			exrock=0
			nothingInR
		ENDIF
	ENDIF
	EXIT SUB
	fBoss:
		exrock=0
		max$=CSTR(ehp)
		whif=""
		battle(en)
END SUB
Function mmSend(ByVal sCommand As String) As Long
	msReturn$ = Space(255)
	iLen% = Len(msReturn)
	mlResult& = mciSendString(sCommand$, msReturn$, iLen%, 0)
	If mlResult = 0 Then
		msReturn$ = RTrim(msReturn$)
		msReturn$ = Left(msReturn$, Len(msReturn$))
	Else
		msReturn$ = ""
	End If
	mmSend = mlResult
End Function
Function playSound(ByVal sFile As String, ByVal sAlias As String) As Long
	Dim lRet&
	lRet& = mmSend("open " & sFile$ & " alias " & sAlias$)
	If lRet& = 0 Then
		lRet& = mmSend("play " & sAlias$)
		playSound = lRet&
	Else
		playSound = lRet&
	Endif
End Function
Function stopSound(ByVal al As String) As Long
	Dim lRes&
	lRes& = mmSend("close " & al$)
	stopSound = lRes&
End Function
SUB savegame()
	o_s=1
	folder$=GETFOLDER()
	IF folder<>"" THEN
		SETCURRFOLDER folder
		os.SETTEXT "Save game - ["+folder+"]"
		os.o_s.SETTEXT "Save"
		suc%=DIALOG(os)
		IF suc%=2 THEN bubby=handle_money(1, 5)
	ELSE
		bub=handle_money(1, 5)
	ENDIF
END SUB
SUB openSave(BYVAL ControlID%, BYVAL Event%)
	ON ERROR GOTO errorHandle
	IF Event=0 THEN
		os.g1.ENABLE 0
		os.g2.ENABLE 0
		os.g3.ENABLE 0
		os.g4.ENABLE 0
		os.g5.ENABLE 0
		os.o_s.ENABLE 0
		os.o_s.SETSTYLE 1
		os.Cancel1.MOVE 132, 116
		IF o_s=0 THEN
			os.o_s.SETSTYLE 2
			os.Cancel1.MOVE 88, 116
		ENDIF
		OPEN "game1.ysv" FOR INPUT AS 9
		LINE INPUT #9, title(1)
		CLOSE 9
		OPEN "game2.ysv" FOR INPUT AS 9
		LINE INPUT #9, title(2)
		CLOSE 9
		OPEN "game3.ysv" FOR INPUT AS 9
		LINE INPUT #9, title(3)
		CLOSE 9
		OPEN "game4.ysv" FOR INPUT AS 9
		LINE INPUT #9, title(4)
		CLOSE 9
		OPEN "game5.ysv" FOR INPUT AS 9
		LINE INPUT #9, title(5)
		CLOSE 9
		IF o_s=0 AND title(1)="(empty)" AND title(2)="(empty)" AND title(3)="(empty)" AND title(4)="(empty)" AND title(5)="(empty)" THEN
			MESSAGE "There are no saved files in this directory."
			os.CLOSEDIALOG 3
		ENDIF
		os.g1.SETTEXT title(1)
		os.g2.SETTEXT title(2)
		os.g3.SETTEXT title(3)
		os.g4.SETTEXT title(4)
		os.g5.SETTEXT title(5)
		IF o_s=0 THEN
			IF title(1)="(empty)" THEN os.b1.ENABLE 0
			IF title(2)="(empty)" THEN os.b2.ENABLE 0
			IF title(3)="(empty)" THEN os.b3.ENABLE 0
			IF title(4)="(empty)" THEN os.b4.ENABLE 0
			IF title(5)="(empty)" THEN os.b5.ENABLE 0
		ENDIF
	ENDIF
	IF Event=2 AND ControlID=6 THEN
		IF chose=0 THEN
			MESSAGE "Please choose a game"
		ELSE
			save(chose)
		ENDIF
	ENDIF
	IF Event=2 AND ControlID=13 AND o_s=1 THEN
		chose=1
		os.g1.ENABLE -1
		os.b1.ENABLE 0
		os.b2.ENABLE 0
		os.b3.ENABLE 0
		os.b4.ENABLE 0
		os.b5.ENABLE 0
		os.o_s.ENABLE -1
	ENDIF
	IF Event=2 AND ControlID=14 AND o_s=1 THEN
		chose=2
		os.g2.ENABLE -1
		os.b1.ENABLE 0
		os.b2.ENABLE 0
		os.b3.ENABLE 0
		os.b4.ENABLE 0
		os.b5.ENABLE 0
		os.o_s.ENABLE -1
	ENDIF
	IF Event=2 AND ControlID=15 AND o_s=1 THEN
		chose=3
		os.g3.ENABLE -1
		os.b1.ENABLE 0
		os.b2.ENABLE 0
		os.b3.ENABLE 0
		os.b4.ENABLE 0
		os.b5.ENABLE 0
		os.o_s.ENABLE -1
	ENDIF
	IF Event=2 AND ControlID=16 AND o_s=1 THEN
		chose=4
		os.g4.ENABLE -1
		os.b1.ENABLE 0
		os.b2.ENABLE 0
		os.b3.ENABLE 0
		os.b4.ENABLE 0
		os.b5.ENABLE 0
		os.o_s.ENABLE -1
	ENDIF
	IF Event=2 AND ControlID=17 AND o_s=1 THEN
		chose=5
		os.g5.ENABLE -1
		os.b1.ENABLE 0
		os.b2.ENABLE 0
		os.b3.ENABLE 0
		os.b4.ENABLE 0
		os.b5.ENABLE 0
		os.o_s.ENABLE -1
	ENDIF
	IF Event=2 AND ControlID=13 AND o_s=0 THEN
		OPEN "game1.ysv" FOR INPUT AS 7
			LINE INPUT #7, iouN$
			LINE INPUT #7, temp$
			set=VAL(temp)
			LINE INPUT #7, temp$
			money=VAL(temp)
			LINE INPUT #7, temp$
			hp=VAL(temp)
			LINE INPUT #7, temp$
			maxhp=VAL(temp)
			LINE INPUT #7, temp$
			attack=VAL(temp)
			LINE INPUT #7, temp$
			defence=VAL(temp)
			LINE INPUT #7, temp$
			level=VAL(temp)
			LINE INPUT #7, temp$
			expo=VAL(temp)
			LINE INPUT #7, temp$
			weapAtt=VAL(temp)
			LINE INPUT #7, temp$
			armDef=VAL(temp)
			LINE INPUT #7, temp$
			hePaid=VAL(temp)
			LINE INPUT #7, temp$
			hePaidA=VAL(temp)
			LINE INPUT #7, currWeap$
			LINE INPUT #7, currArmor$
			LINE INPUT #7, temp$
			cure=VAL(temp)
			LINE INPUT #7, temp$
			bomb=VAL(temp)
			LINE INPUT #7, tempa$
			LINE INPUT #7, tempb$
			LINE INPUT #7, tempc$
			LINE INPUT #7, tempd$
			LINE INPUT #7, tempe$
			IF tempa$="T" THEN haveP=TRUE ELSE haveP=FALSE
			IF tempb$="T" THEN haveSR=TRUE ELSE haveSR=FALSE
			IF tempc$="T" THEN haveBR=TRUE ELSE haveBR=FALSE
			IF tempd$="T" THEN talkFT=TRUE ELSE talkFT=FALSE
			IF tempe$="T" THEN odb=TRUE ELSE odn=FALSE
		CLOSE 7
		os.CLOSEDIALOG 3
		whereAmI
	ENDIF
	IF Event=2 AND ControlID=14 AND o_s=0 THEN
		OPEN "game2.ysv" FOR INPUT AS 7
			LINE INPUT #7, iouN$
			LINE INPUT #7, temp$
			set=VAL(temp)
			LINE INPUT #7, temp$
			money=VAL(temp)
			LINE INPUT #7, temp$
			hp=VAL(temp)
			LINE INPUT #7, temp$
			maxhp=VAL(temp)
			LINE INPUT #7, temp$
			attack=VAL(temp)
			LINE INPUT #7, temp$
			defence=VAL(temp)
			LINE INPUT #7, temp$
			level=VAL(temp)
			LINE INPUT #7, temp$
			expo=VAL(temp)
			LINE INPUT #7, temp$
			weapAtt=VAL(temp)
			LINE INPUT #7, temp$
			armDef=VAL(temp)
			LINE INPUT #7, temp$
			hePaid=VAL(temp)
			LINE INPUT #7, temp$
			hePaidA=VAL(temp)
			LINE INPUT #7, currWeap$
			LINE INPUT #7, currArmor$
			LINE INPUT #7, temp$
			cure=VAL(temp)
			LINE INPUT #7, temp$
			bomb=VAL(temp)
			LINE INPUT #7, tempa$
			LINE INPUT #7, tempb$
			LINE INPUT #7, tempc$
			LINE INPUT #7, tempd$
			LINE INPUT #7, tempe$
			IF tempa$="T" THEN haveP=TRUE ELSE haveP=FALSE
			IF tempb$="T" THEN haveSR=TRUE ELSE haveSR=FALSE
			IF tempc$="T" THEN haveBR=TRUE ELSE haveBR=FALSE
			IF tempd$="T" THEN talkFT=TRUE ELSE talkFT=FALSE
			IF tempe$="T" THEN odb=TRUE ELSE odn=FALSE
		CLOSE 7
		os.CLOSEDIALOG 3
		whereAmI
	ENDIF
	IF Event=2 AND ControlID=15 AND o_s=0 THEN
		OPEN "game3.ysv" FOR INPUT AS 7
			LINE INPUT #7, iouN$
			LINE INPUT #7, temp$
			set=VAL(temp)
			LINE INPUT #7, temp$
			money=VAL(temp)
			LINE INPUT #7, temp$
			hp=VAL(temp)
			LINE INPUT #7, temp$
			maxhp=VAL(temp)
			LINE INPUT #7, temp$
			attack=VAL(temp)
			LINE INPUT #7, temp$
			defence=VAL(temp)
			LINE INPUT #7, temp$
			level=VAL(temp)
			LINE INPUT #7, temp$
			expo=VAL(temp)
			LINE INPUT #7, temp$
			weapAtt=VAL(temp)
			LINE INPUT #7, temp$
			armDef=VAL(temp)
			LINE INPUT #7, temp$
			hePaid=VAL(temp)
			LINE INPUT #7, temp$
			hePaidA=VAL(temp)
			LINE INPUT #7, currWeap$
			LINE INPUT #7, currArmor$
			LINE INPUT #7, temp$
			cure=VAL(temp)
			LINE INPUT #7, temp$
			bomb=VAL(temp)
			LINE INPUT #7, tempa$
			LINE INPUT #7, tempb$
			LINE INPUT #7, tempc$
			LINE INPUT #7, tempd$
			LINE INPUT #7, tempe$
			IF tempa$="T" THEN haveP=TRUE ELSE haveP=FALSE
			IF tempb$="T" THEN haveSR=TRUE ELSE haveSR=FALSE
			IF tempc$="T" THEN haveBR=TRUE ELSE haveBR=FALSE
			IF tempd$="T" THEN talkFT=TRUE ELSE talkFT=FALSE
			IF tempe$="T" THEN odb=TRUE ELSE odn=FALSE
		CLOSE 7
		os.CLOSEDIALOG 3
		whereAmI
	ENDIF
	IF Event=2 AND ControlID=16 AND o_s=0 THEN
		OPEN "game4.ysv" FOR INPUT AS 7
			LINE INPUT #7, iouN$
			LINE INPUT #7, temp$
			set=VAL(temp)
			LINE INPUT #7, temp$
			money=VAL(temp)
			LINE INPUT #7, temp$
			hp=VAL(temp)
			LINE INPUT #7, temp$
			maxhp=VAL(temp)
			LINE INPUT #7, temp$
			attack=VAL(temp)
			LINE INPUT #7, temp$
			defence=VAL(temp)
			LINE INPUT #7, temp$
			level=VAL(temp)
			LINE INPUT #7, temp$
			expo=VAL(temp)
			LINE INPUT #7, temp$
			weapAtt=VAL(temp)
			LINE INPUT #7, temp$
			armDef=VAL(temp)
			LINE INPUT #7, temp$
			hePaid=VAL(temp)
			LINE INPUT #7, temp$
			hePaidA=VAL(temp)
			LINE INPUT #7, currWeap$
			LINE INPUT #7, currArmor$
			LINE INPUT #7, temp$
			cure=VAL(temp)
			LINE INPUT #7, temp$
			bomb=VAL(temp)
			LINE INPUT #7, tempa$
			LINE INPUT #7, tempb$
			LINE INPUT #7, tempc$
			LINE INPUT #7, tempd$
			LINE INPUT #7, tempe$
			IF tempa$="T" THEN haveP=TRUE ELSE haveP=FALSE
			IF tempb$="T" THEN haveSR=TRUE ELSE haveSR=FALSE
			IF tempc$="T" THEN haveBR=TRUE ELSE haveBR=FALSE
			IF tempd$="T" THEN talkFT=TRUE ELSE talkFT=FALSE
			IF tempe$="T" THEN odb=TRUE ELSE odn=FALSE
		CLOSE 7
		os.CLOSEDIALOG 3
		whereAmI
	ENDIF
	IF Event=2 AND ControlID=17 AND o_s=0 THEN
		OPEN "game5.ysv" FOR INPUT AS 7
			LINE INPUT #7, iouN$
			LINE INPUT #7, temp$
			set=VAL(temp)
			LINE INPUT #7, temp$
			money=VAL(temp)
			LINE INPUT #7, temp$
			hp=VAL(temp)
			LINE INPUT #7, temp$
			maxhp=VAL(temp)
			LINE INPUT #7, temp$
			attack=VAL(temp)
			LINE INPUT #7, temp$
			defence=VAL(temp)
			LINE INPUT #7, temp$
			level=VAL(temp)
			LINE INPUT #7, temp$
			expo=VAL(temp)
			LINE INPUT #7, temp$
			weapAtt=VAL(temp)
			LINE INPUT #7, temp$
			armDef=VAL(temp)
			LINE INPUT #7, temp$
			hePaid=VAL(temp)
			LINE INPUT #7, temp$
			hePaidA=VAL(temp)
			LINE INPUT #7, currWeap$
			LINE INPUT #7, currArmor$
			LINE INPUT #7, temp$
			cure=VAL(temp)
			LINE INPUT #7, temp$
			bomb=VAL(temp)
			LINE INPUT #7, tempa$
			LINE INPUT #7, tempb$
			LINE INPUT #7, tempc$
			LINE INPUT #7, tempd$
			LINE INPUT #7, tempe$
			IF tempa$="T" THEN haveP=TRUE ELSE haveP=FALSE
			IF tempb$="T" THEN haveSR=TRUE ELSE haveSR=FALSE
			IF tempc$="T" THEN haveBR=TRUE ELSE haveBR=FALSE
			IF tempd$="T" THEN talkFT=TRUE ELSE talkFT=FALSE
			IF tempe$="T" THEN odb=TRUE ELSE odn=FALSE
		CLOSE 7
		os.CLOSEDIALOG 3
		whereAmI
	ENDIF
	EXIT SUB
	errorHandle:
		OPEN "game1.ysv" FOR OUTPUT AS 8
		PRINT #8, "(empty)"
		CLOSE 8
		OPEN "game2.ysv" FOR OUTPUT AS 8
		PRINT #8, "(empty)"
		CLOSE 8
		OPEN "game3.ysv" FOR OUTPUT AS 8
		PRINT #8, "(empty)"
		CLOSE 8
		OPEN "game4.ysv" FOR OUTPUT AS 8
		PRINT #8, "(empty)"
		CLOSE 8
		OPEN "game5.ysv" FOR OUTPUT AS 8
		PRINT #8, "(empty)"
		CLOSE 8
	RESUME
END SUB
SUB monitor()
	set=2
	game.one.ENABLE 0
	game.three.ENABLE 0
	game.four.ENABLE 0
	game.five.ENABLE 0
	game.two.ENABLE 0
	sayt("Monitor Station")
	a$=CSTR(money%)
	b$=CSTR(hp%)+"/"+CSTR(maxhp%)
	c$=CSTR(attack+weapAtt)
	d$=CSTR(defence+armDef)
	e$=STR(expo%)
	f$=STR(level%)
	saym("You walk up to the monitor to find your stats."+CHR(13)+"Money: $"+a+CHR(13)+"Health: "+b+CHR(13)+"Attack: "+c+CHR(13)+"Defence: "+d+CHR(13)+"Exerience Points: "+e+CHR(13)+"Level: "+f+CHR(13)+"Cure Potions: "+CSTR(cure)+CHR(13)+"Bombs: "+CSTR(bomb)+CHR(13)+"Weapon: "+currWeap+CHR(13)+"Armour: "+currArmor+CHR(13)+"-----------------------"+CHR(13)+"6 - Leave Station")
END SUB
SUB weapShop()
	set=2
	shp=1
	sayt("Ye Ole Weapon Shoppe")
	IF odb THEN
		IF oldSw<>"" THEN
			saym("Wow says the shopkeeper as you walk in! I see you have the mighty Dragon's Bane. I'll take that old "+oldSw+" from yah for $"+CSTR(hePaid \ 2)+"."+br+"- - - - - - - - - - - - - - - - - - -"+br+"6 - Leave shop")
			oldSw$=""
			tog%=hePaid \ 2
			ggggg=handle_money(1, tog)
			game.one.ENABLE 0
			game.two.ENABLE 0
			game.three.ENABLE 0
			game.four.ENABLE 0
			game.five.ENABLE 0
		ELSE
			saym("Hello again, you don't have any business in here - go kill Kamul!"+br+"- - - - - - - - - - - - - - - - - - -"+br+"6 - Leave shop")
			game.one.ENABLE 0
			game.two.ENABLE 0
			game.three.ENABLE 0
			game.four.ENABLE 0
			game.five.ENABLE 0
		ENDIF
	ELSE
		game.one.ENABLE -1
		game.two.ENABLE -1
		game.three.ENABLE -1
		game.four.ENABLE -1
		game.five.ENABLE -1
		game.six.ENABLE -1
		disp$=""
		FOR the=1 TO 5
			weap(the)=LEFT(weaponList(the), INSTR(weaponList(the), ";")-1)
			temp$=MID(weaponList(the), INSTR(weaponList(the), ":")+1)
			addon(the)=VAL(temp$)
			IF the=5 THEN it%=4 ELSE it%=3
			temp$=MID(weaponList(the), INSTR(weaponList(the), ";")+1, it%)
			price(the)=VAL(temp)
			wet$=STR(the)
			p$=STR(price(the))
			w$=STR(weap(the))
			disp$=disp$+wet$+" - "+w+" . . . . . $"+p+CHR(13)
		NEXT the
		disp="You stroll into the weapon shop to see what is for sale"+CHR(13)+" -------------------"+CHR(13)+disp+"6 - Leave store"
		saym(disp)
	ENDIF
END SUB
SUB armShop()
	shp=2
	set=2
	sayt("Ye Ol'Armour Shoppe")
	game.one.ENABLE -1
	game.two.ENABLE -1
	game.three.ENABLE -1
	game.four.ENABLE -1
	game.five.ENABLE -1
	game.six.ENABLE -1
	disp$=""
	FOR the=1 TO 5
		arm(the)=LEFT(armorList(the), INSTR(armorList(the), ";")-1)
		temp$=MID(armorList(the), INSTR(armorList(the), ":")+1)
		addon(the)=VAL(temp$)
		temp$=MID(armorList(the), INSTR(armorList(the), ";")+1, 3)
		price(the)=VAL(temp)
		wet$=STR(the)
		p$=STR(price(the))
		k$=STR(arm(the))
		disp$=disp$+wet$+" - "+k+" . . . . . $"+p+CHR(13)
	NEXT the
	disp="You stroll into the armour shop to see what is for sale"+CHR(13)+" -------------------"+CHR(13)+disp+"6 - Leave store"
	saym(disp)
	
END SUB
SUB whereAmI()
	IF set=0 THEN
		game.one.ENABLE -1
		game.two.ENABLE -1
		game.three.ENABLE -1
		game.four.ENABLE 0
		game.five.ENABLE 0
		game.six.ENABLE 0
		outOfTown
	ELSEIF set=1 THEN
		inTown
	ENDIF
END SUB
FUNCTION handle_money(BYVAL how%, BYREF amount%) as BOOLEAN
	IF how=0 THEN
		IF amount > money THEN
			handle_money=FALSE
		ELSE
			money=money-amount
			handle_money=TRUE
		ENDIF
	ELSE
		money=money+amount
		handle_money=TRUE
	ENDIF
END FUNCTION
SUB buy(BYVAL num%)
	IF handle_money(0, price(num))=TRUE THEN
		IF hePaid<>0 THEN
			IF code="ProDiGY_ ruLeZ!" THEN sew%=FIX(hePaid*2) ELSE sew%=FIX(hePaid/2)
			stew$=CSTR(sew)
			saym(disp+CHR(13)+CHR(13)+"Thank you, I'll give you $"+stew+" for your "+currWeap)
			duh=handle_money(1, sew)
		ELSE
			saym(disp+CHR(13)+CHR(13)+"Thank you!")
		ENDIF
		currWeap=weap(num)
		hePaid=price(num)
		weapAtt=addon(num)
	ELSE
		saym(disp+CHR(13)+CHR(13)+"I'm sorry, but you can't afford that!")
	ENDIF
END SUB
SUB buyA(BYVAL nam%)
	IF handle_money(0, price(nam))=TRUE THEN
		IF hePaidA<>0 THEN
			IF code="ProDiGY_ ruLeZ!" THEN sew%=FIX(hePaidA*2) ELSE sew%=FIX(hePaidA/2)
			stew$=CSTR(sew)
			saym(disp+CHR(13)+CHR(13)+"Thank you, I'll give you $"+stew+" for your "+currArmor)
			duh=handle_money(1, sew)
		ELSE
			saym(disp+CHR(13)+CHR(13)+"Thank you!")
		ENDIF
		currArmor=arm(nam)
		hePaidA=price(nam)
		armDef=addon(nam)
	ELSE
		saym(disp+CHR(13)+CHR(13)+"I'm sorry, but you can't afford that!")
	ENDIF
END SUB
SUB cheat()
ON ERROR GOTO hey
	OPEN "cbnsca.nil" FOR INPUT AS 5
	LINE INPUT #5, code$
	CLOSE 5
aha:
EXIT SUB
hey:

RESUME AT aha
END SUB
SUB save(BYVAL where%)
	IF where=1 THEN
		OPEN "game1.ysv" FOR OUTPUT AS 6
		gamo$=os.g1.GETTEXT()
		IF gamo="" OR gamo="(empty)" THEN MESSAGE "You can't name it that!" ELSE PRINT #6, gamo
	ELSEIF where=2 THEN
		OPEN "game2.ysv" FOR OUTPUT AS 6
		gamo$=os.g2.GETTEXT()
		IF gamo="" OR gamo="(empty)" THEN MESSAGE "You can't name it that!" ELSE PRINT #6, gamo
	ELSEIF where=3 THEN
		OPEN "game3.ysv" FOR OUTPUT AS 6
		gamo$=os.g3.GETTEXT()
		IF gamo="" OR gamo="(empty)" THEN MESSAGE "You can't name it that!" ELSE PRINT #6, gamo
	ELSEIF where=4 THEN
		OPEN "game4.ysv" FOR OUTPUT AS 6
		gamo$=os.g4.GETTEXT()
		IF gamo="" OR gamo="(empty)" THEN MESSAGE "You can't name it that!" ELSE PRINT #6, gamo
	ELSE
		OPEN "game5.ysv" FOR OUTPUT AS 6
		gamo$=os.g5.GETTEXT()
		IF gamo="" OR gamo="(empty)" THEN MESSAGE "You can't name it that!" ELSE PRINT #6, gamo
	ENDIF
	IF gamo<>"" AND gamo<>"(empty)" THEN
		IF haveP THEN a$="T" ELSE a$="F"
		IF haveSR THEN b$="T" ELSE b$="F"
		IF haveBR THEN c$="T" ELSE c$="F"
		IF talkFT THEN d$="T" ELSE d$="F"
		IF odb THEN e$="T" ELSE e$="F"
		o%=1
		PRINT #6, CSTR(o)
		PRINT #6, CSTR(money)
		PRINT #6, CSTR(hp)
		PRINT #6, CSTR(maxhp)
		PRINT #6, CSTR(attack)
		PRINT #6, CSTR(defence)
		PRINT #6, CSTR(level)
		PRINT #6, CSTR(expo)
		PRINT #6, CSTR(weapAtt)
		PRINT #6, CSTR(armDef)
		PRINT #6, CSTR(hePaid)
		PRINT #6, CSTR(hePaidA)
		PRINT #6, currWeap
		PRINT #6, currArmor
		PRINT #6, CSTR(cure)
		PRINT #6, CSTR(bomb)
		PRINT #6, a
		PRINT #6, b
		PRINT #6, c
		PRINT #6, d
		PRINT #6, e
		CLOSE 6
		os.CLOSEDIALOG 3
	ENDIF
END SUB
SUB teller()
	set=2
	telthis$=CHR(13)+"-----------------------"+CHR(13)+"6 - Leave Fortune Tellers Tent"
	game.one.ENABLE 0
	game.three.ENABLE 0
	game.four.ENABLE 0
	game.five.ENABLE 0
	game.two.ENABLE 0
	IF haveP THEN
		IF talkFT THEN
			sayt("Fortune Teller")
			IF odb THEN
				saym("Now that you have the Dragon's Bane you are unstoppable! GO - KILL KAMUL!!"+telthis)
			ELSE
				saym("Go! Find the sword and defeat the evil spirit Kamul!"+telthis)
			ENDIF
		ELSE
			sayt("Fortune Teller")
			saym("Thank you so much for finding my pendant, to repay you I will tell you about the Dragon's Bane. It is a mystical sword that is guarded by a wizard name Morlin in a cave not far from here. Explore the rocky area to find it."+telthis)
			talkFT=TRUE
		ENDIF
	ELSE
		IF level=1 THEN
			sayt("Fortune Teller") : saym(tMess1+telthis)
		ELSEIF level=2 THEN
			sayt("Fortune Teller") : saym(tMess2+telthis)
		ELSEIF level=3 THEN
			sayt("Fortune Teller") : saym(tMess3+telthis)
		ELSEIF level=4 THEN
			sayt("Fortune Teller") : saym(tMess4+telthis)
		ELSE
			sayt("Fortune Teller") : saym(tMess5+telthis)
		ENDIF
	ENDIF
END SUB
FUNCTION fight_this(BYVAL what$) as BOOLEAN
	hodere%=MESSAGEBOX("You are approached by a(n) "+what+"!"+CHR(13)+"Fight it?", what, 4 OR 32)
	IF hodere%=6 THEN fight_this=TRUE ELSE fight_this=FALSE
END FUNCTION
SUB battle(BYVAL ani$)
	set=10
	sayt(ani)
	saythis$=ani+"'s Health: "+CSTR(ehp)+"/"+max+CHR(13)+"Your Health: "+CSTR(hp)+"/"+CSTR(maxhp)+CHR(13)+"---------------------------"+CHR(13)+"1 - Attack"+CHR(13)+"2 - Bomb"+CHR(13)+"3 - Cure"+CHR(13)+"4 - Run"
	saym(saythis+whif)
END SUB
SUB attack1()
	tot%=attack+weapAtt
	tot%=(tot*2)+2
	RANDOMIZE
	take%=RND(tot)
	take%=ABS(FIX(take))
	IF boss<>"" THEN take%=(take \ 3)*2
	ehp=ehp-take
	IF ehp<=0 THEN
		whif=CHR(13)+"You hit with: "+CSTR(take)+CHR(13)+CHR(13)+"The "+en+" was defeated!"+CHR(13)+"You get "+CSTR(emon%)+" gold and "+CSTR(eex%)+" experience points!"+CHR(13)+"---------------------"+CHR(13)+"1 - Continue"
		IF boss="morlin" THEN whif=CHR(13)+"You hit with: "+CSTR(take)+CHR(13)+CHR(13)+en+" was defeated!"+CHR(13)+"You grab the mighty Dragon's Bane in your hands and feel the raw power!"+CHR(13)+"You get "+CSTR(emon%)+" gold and "+CSTR(eex%)+" experience points!"+CHR(13)+"---------------------"+CHR(13)+"1 - Continue" : odb=TRUE : oldSw=currWeap : currWeap="Dragon's Bane" : weapAtt=33 : boss=""
		IF boss="kamul" THEN GOTO winned
		saym(saythis+whif)
		expo=expo+eex
		money=money+emon
		set=11
		game.two.ENABLE 0
		game.three.ENABLE 0
		game.four.ENABLE 0
		game.five.ENABLE 0
		game.six.ENABLE 0
		saym(whif)
		IF expo>=lvl(level) THEN upLevel
	ELSE
		' -------------------
		bite%=(CINT(max$))+2
		RANDOMIZE
		bite%=RND(bite)
		bite%=ABS(FIX(bite))
		bloc%=defence+armDef
		bite%=bite-(bloc \ 2)
		IF bite<0 THEN bite=0
		hp=hp-bite
		IF hp<=0 THEN
			IF boss="kamul" THEN
				saym("As your health runs out Kamul grins wickedly then throws you into a tree. You are laying there helplessly when you start screaming! Kamul is using a heat spell to melt your legs! You are unable to lapse into unconsciousness as Kamul is controlling your mind. Your bloodcurdling screams are lost in the forest. You are staring at your bones as the flesh has already bubbled off your legs and is starting at your arms. Just then Kamul knocks over a tree and a large branch is thrust through you stomach. You slowly die in the most painful death possible as your gastric acids leak into your bloodstream and corrode your organs"+br+"YOU DIE!!")
			ELSE
				saym("The "+en+" killed you with a: "+CSTR(bite)+CHR(13)+CHR(13)+"YOU DIE!!!")
			ENDIF
			game.one.SETSTYLE 2
			game.two.SETSTYLE 2
			game.three.SETSTYLE 2
			game.four.SETSTYLE 2
			game.five.SETSTYLE 2
			game.six.SETSTYLE 2
			boss=""
		ELSE
			whif=CHR(13)+"You hit with: "+CSTR(take)+CHR(13)+en+" hit with: "+CSTR(bite)
			battle(en$)
		ENDIF
	ENDIF
EXIT SUB
winned:
	boss=""
	youBeatGame
END SUB
SUB upLevel()
	IF level<15 THEN
		level=level+1
		attack=attack+2
		defence=defence+2
		maxhp=maxhp+8
		kkk$=game.main.GETTEXT()
		saym(kkk+CHR(13)+CHR(13)+"You went up a level!"+CHR(13)+"Your Health is now: "+CSTR(maxhp)+CHR(13)+"Your Attack is "+CSTR(attack)+" and your Defence is "+CSTR(defence))

	ENDIF
END SUB
SUB genStore()
	set=2
	shp=3
	game.one.ENABLE -1
	game.two.ENABLE -1
	game.three.ENABLE -1
	game.four.ENABLE -1
	game.five.ENABLE 0
	game.six.ENABLE -1
	sayt("General Store")
	IF haveSR THEN
		trade
		game.one.ENABLE 0
		game.two.ENABLE 0
		game.three.ENABLE 0
		game.four.ENABLE 0
		qqq$=game.main.GETTEXT()
		saym(qqq+CHR(13)+"--------------------"+CHR(13)+"6 - Leave store")
	ELSE
		saym("The owner smiles as you walk in. 'Can I help you?':"+CHR(13)+"1 - Cure potion . . . . . $10"+CHR(13)+"2 - Bomb . . . . . $15"+CHR(13)+"3 - Save your game . . . . . $5"+CHR(13)+"4 - Spend the night . . . . . $35"+CHR(13)+"6 - Leave store")
	ENDIF
END SUB
SUB cure1()
	IF cure>0 THEN
		hp=hp+10
		IF hp>maxhp THEN hp=maxhp
		cure=cure-1
		battle(en)
	ELSE 
		saym(saythis+CHR(13)+CHR(13)+"You don't have any cure potions!")
	ENDIF
END SUB
SUB bomb1()
	IF boss="kamul"  THEN
		ooo$=game.main.GETTEXT()
		saym(ooo+br+br+"Nothing except the Dragon's Bane will affect Kamul")
	ELSE
	IF bomb>0 THEN
		bomb=bomb-1
		take%=20
		ehp=ehp-take
		IF ehp<=0 THEN
			whif=CHR(13)+"You bomb with: "+CSTR(take)+CHR(13)+CHR(13)+"The "+en+" was defeated!"+CHR(13)+"You get "+CSTR(emon%)+" gold and "+CSTR(eex%)+" experience points!"+CHR(13)+"---------------------"+CHR(13)+"1 - Continue"
			IF boss="morlin" THEN whif=CHR(13)+"You bomb with: "+CSTR(take)+CHR(13)+CHR(13)+en+" was defeated!"+CHR(13)+"You grab the mighty Dragon's Bane in your hands and feel the raw power!"+CHR(13)+"You get "+CSTR(emon%)+" gold and "+CSTR(eex%)+" experience points!"+CHR(13)+"---------------------"+CHR(13)+"1 - Continue" : odb=TRUE : oldSw=currWeap : currWeap="Dragon's Bane" : weapAtt=33 : boss=""
			saym(saythis+whif)
			expo=expo+eex
			money=money+emon
			IF expo>=lvl(level) THEN upLevel
			set=11
			game.two.ENABLE 0
			game.three.ENABLE 0
			game.four.ENABLE 0
			game.five.ENABLE 0
			game.six.ENABLE 0
			saym(whif)
		ELSE
			' -------------------
			bite%=(CINT(max$)*2)+2
			RANDOMIZE
			bite%=RND(bite)
			bite%=ABS(FIX(bite))
			bloc%=defence+armDef
			bite%=bite-bloc
			IF bite<0 THEN bite=0
			hp=hp-bite
			IF hp<=0 THEN
				saym("The "+en+" killed you with a: "+CSTR(bite)+CHR(13)+CHR(13)+"YOU DIE!!!")
				game.one.SETSTYLE 2
				game.two.SETSTYLE 2
				game.three.SETSTYLE 2
				game.four.SETSTYLE 2
				game.five.SETSTYLE 2
				game.six.SETSTYLE 2
				boss=""
			ELSE
				whif=CHR(13)+"You bomb with: "+CSTR(take)+CHR(13)+en+" hit with: "+CSTR(bite)
				battle(en$)
			ENDIF
		ENDIF
	ELSE
		saym(saythis+CHR(13)+CHR(13)+"You don't have any bombs!")
	ENDIF
	ENDIF
END SUB
SUB run()
	IF boss<>"" THEN
		fff$=game.main.GETTEXT()
		saym(fff$+CHR(13)+CHR(13)+"You can't run away from a boss!")
	ELSE
		IF cantRun THEN
			fff$=game.main.GETTEXT()
			saym(fff+CHR(13)+CHR(13)+"You are unable to run away!")
		ELSE
			RANDOMIZE
			runnin%=ABS(FIX(RND(22)))
			IF runnin=2 OR runnin=6 OR runnin=9 THEN
				fff$=game.main.GETTEXT()
				saym(fff+CHR(13)+CHR(13)+"You were able to run away!")
				cantRun=TRUE
			ELSE
				fff$=game.main.GETTEXT()
				saym(fff$+CHR(13)+CHR(13)+"You are unable to run away!")
			ENDIF
		ENDIF
	ENDIF
END SUB
SUB foundCave(BYVAL how%)
	sayt("The Abyss")
	IF how=0 THEN
		saym("You come across a cave in the ground. This must the one where the sword and Morlin are. Oh great! You don't have a rope. Better go find one."+CHR(13)+"- - - - - - - - - - - - - -"+CHR(13)+"1 - Continue")
		set=11
		oldset=4
		exrock=0
		game.two.ENABLE 0
		game.three.ENABLE 0
		game.four.ENABLE 0
	ELSEIF how=1 THEN
		saym("You come across a cave in the ground. This must the one where the sword and Morlin are. Do you want to climb in with your rope?"+CHR(13)+" - - - - - - - - - - - - - - -"+CHR(13)+"1 - Sure climb in!"+CHR(13)+"2 - No I think I'll just continue to explore")
		set=9
		exrock=0
		game.two.ENABLE -1
		game.three.ENABLE 0
		game.four.ENABLE 0
	ENDIF
END SUB
SUB goInCave()
	IF haveBR THEN
		boss="morlin"
		prepfight
	ELSE
		saym("Oh no!!! This rope is to weak and rotten to hold you! You plunge into the inky blackness of the cave! You land on a sharp spear of rock which thrusts itself through your frail carcass. Your last sight before you fall into eternal darkness is of a glint of metal and two glowing eyes."+CHR(13)+CHR(13)+"YOU DIE!!!!!")
		game.one.SETSTYLE 2
		game.two.SETSTYLE 2
		game.three.SETSTYLE 2
		game.four.SETSTYLE 2
		game.five.SETSTYLE 2
		game.six.SETSTYLE 2
	ENDIF
END SUB
SUB youBeatGame()
	sayt("YOU WIN!!!")
	saym("You strike the fatal blow to Kamul. He drops to the ground hissing and gurgling. You are the hero of the town!"+br+"CONGRADULATIONS!!!!!!!"+CHR(13)+CHR(13)+"You have beaten Yearlings!"+CHR(13)+"- - - - - - - - - - - - - - - - - - - - - - - -"+CHR(13)+"Design: Colin Bate"+br+"Programming: Colin Bate"+br+"Story: Colin Bate"+br+"Thank You!")
	game.one.SETSTYLE 2
	game.two.SETSTYLE 2
	game.three.SETSTYLE 2
	game.four.SETSTYLE 2
	game.five.SETSTYLE 2
	game.six.SETSTYLE 2
	FOR fart%=1 TO 10
		BEEP
		WAIT FOR 1
	NEXT fart
END SUB
SUB forestYet()
	IF level>=13 THEN
		vvv$=game.main.GETTEXT()
		saym(vvv+br+"4 - Doomed Woods")
		game.four.ENABLE -1		
	ENDIF
END SUB
SUB enterForest()
	IF odb THEN
		boss="kamul"
		prepfight
	ELSE
		saym("You step up to the mighty Kamul and realize that you forgot the Dragon's Bane. Kamul grins wickedly then throws you into a tree. You are laying there helplessly when you start screaming! Kamul is using a heat spell to melt your legs! You are unable to lapse into unconsciousness as Kamul is controlling your mind. Your bloodcurdling screams are lost in the forest. You are staring at your bones as the flesh has already bubbled off your legs and is starting at your arms. Just then Kamul knocks over a tree and a large branch is thrust through you stomach. You slowly die in the most painful death possible as your gastric acids leak into your bloodstream and corrode your organs"+br+"YOU DIE!!")
		game.one.SETSTYLE 2
		game.two.SETSTYLE 2
		game.three.SETSTYLE 2
		game.four.SETSTYLE 2
		game.five.SETSTYLE 2
		game.six.SETSTYLE 2
	ENDIF
END SUB
