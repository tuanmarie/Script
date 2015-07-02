DelayAction(function()
 
local users = { "yourlogingnamehere
hackedhacker
alkanna
troni1278
skribbs
xxlarsyxx
taistelu
erwinbeck
semtize
ejdernefesi
hestia
sabaku
andreksu
keoshin
ghostshank
nightmare
blm95
kainv2
imathhater
xffffa
heist
weeeqt
eway86
vellusta
linus van pelt
bestplox
d3dm4n
visionsz
nestle
skitzo13337
solenrus
bookuu
chrissetzer
27032704
melody
challenger12345
leqos
apersonliving
swain
lnteractive
plobrother
cryo
107220663
ki88318808
errinqq
ljk3322
eriszen
hornax
rewind
bistom
mewkyy
phbn93
zderekzz
pok
ailikes
dyingman101
diwas89
norrin
recoba20
haliax
shivan
jujupie
deeka
mrsaluto
smetsson
peacedude_11
a822022
rayvagio
johay
cronicsb
nimus14
l4a
vivi
t3k
ghostrider9310
vinc9993
xpersona
alz337
countergamer24
el mamuth
hassliebe
birdpoodan
helloworld12
tacd
xero666
lordfinder
phoeb
ongie119
traktor
maxemz
loluufd
omfgabriel
cincy91
bibanu
methodxb
emirc
chrisjke
legotya
raz
eunn
boto256
haitashe
pande
chris787n
darktsuboy
benito18
quixor329
walking hell
kingkidd
q179339065
xzz
rafaelj
bobafett141
phexon
nicholasrowan
teino
jmoney
dane517
synchrodoom
mudge
vortur
pba
rep09
dienofail
razzko
afh100
myroomun
sofnyx
lukout
floresrikko
kok000
dzombz
fragmot
flavor2443
brnzao1
maestro29
pirate127
enzyme
wojtekson16
raingul
wocjf7245
baule17
paron1
orgamarius
ee4hire
slashxcdoe
xvartx
424665431
ijustwannaleech
dontstephere
xxgowxx
pqmailer
toxicteddy
woddystory
lunatix
paradoxel
pbp1221990
lancai
omnipot3nt
soslw123
jinear
spydre
haxn23
frosttfire
jeino
armani
tostii
endinglegacy
katrini
nil
kaotik
maauh
lienniar
begodon
wildflower1
meuovo
griken
magus5200
lastchicken
kbcowboy
ires
golgari01
liquidace
robtomo
iluvlamastaf
banned4haxx
rickisme
cbillups205
nommi
biggin3
hyper689
random919
xruinfx
pcharlesaa
nathanha20
wtayllor
funsize
tutuxich
lolnodawg
gldennishk
xii future
blackhype
sunnr
kafetao
surrealpower
crackle
uhndead
gee4hire
xthanhz
zzyzxer
kihan112
teh_m4st3r
siwon1459
kirewade
collster37
johan95
martsen244
sillyfang
timmy16744
thenitrozyniak
shadybs
cromer
shinwoojin
odunsevici
atl
bstokell
asiangirl
xll.de
rene_gahe
gatugeniet
pikaboo
dragonne
sharge
lukeyboy89
midnight123
wukeokok
frylockxxx
scruffles
salnwa
lhr
isintom
andyi
cbkixo
g0rning
mrleo
tilt
changster109
aking92
tjtjsqh
kaiori93
joeshmo
741865447
scrltvx
hahahax
anekraf
manager9090
hans_meier
krosano
typenine
bankreis
toxic 123
phebos
makelovein
devo01234
qwe
midorfeed
xkiyusx
takal57
iodas1
limany
fuzzjp
jason1742
olisky
whiteknight
markapril
herpaderpa123
silent84
xiaomage
deviruchies
whitemvcxxj
pyrophenix
pimpstick
postmeridiem
fireworka
xxbrteamxx
laysbbq
dcnews
xnoregretz2u
fifawinner
volkanyx
jrem11
chr1styano
max6020
ioedaq4
humpex
rafaelinux
deathnow
hiujie
widelove
dxbkillerman2
nicaboy
bedaky
serenity
exile
pappsen
lexxes" }
 
local user = users[ math.random(#users) ]
 
local oldinfo = debug.getinfo
 
_G.debug.getinfo = function(func, what)
  local info = oldinfo(func, what)
 
  if func == debug.getinfo then
    info = oldinfo(oldinfo, what)
    info.func = debug.getinfo
  elseif func == GetUser then
    _G.GetUser = function() return user end
  end
 
  return info
end
 
--[[
  -- Marksman's Mighty Assistant ----------------------------------------------------
  - Features:
      -- Supports VIPS and Free users ---------------------------
      -> Superb orbwalking:
           - Takes into account attack speed instantly(This allows to play Jinx/Varus/etc.. without any problems. Moreover there no EXHAUST glitch)
           - Takes into account Auto-Attack Canceling(If your auto attack gets canceled for whatever reason(for ex.: dodging skillshots), you will start auto attacking right away)
           - Takes into account MAX ranges.
           - Takes into account AutoAttack resetting spells, furthermore Auto-Attack > Reset Spell > Auto Attack combos(Targeted spells only atm).
                >> resetAttackSpells = {
                    MissFortune = _Q, Rengar  = _Q,  Sivir = _W, Vi          = _E, Tristana = _E,
                    MonkeyKing  = _Q, Lucian  = _Q,  Vayne = _Q, KogMaw      = _Q, Yorick   = _Q,
                    Cassiopeia  = _E, Hecarim = _Q,  Jax   = _W, Shyvana     = _Q, XinZhao  = _Q,
                    Blitzcrank  = _E, Darius  = _W,  Fiora = _E, Gangplank   = _Q, Nasus    = _Q,
                    Garen       = _Q, Jayce   = _W,  Leona = _Q, Mordekaiser = _Q, Volibear = _Q,
                    Nautilus    = _W, Nidalee = _Q,  Poppy = _Q, Renekton    = _W,
                    Sona        = _Q, Talon   = _Q,  Teemo = _Q, Trundle     = _Q,
                }
           - Item(Bilgewater Cutlass, Blade of the Ruined King, Hextech Gunblade, Hydra, Tiamat) support.
      -> Auto Last Hitting:
           - All the information is used from the game files via Spell-Database library.
           - Supports ALL melee/ranged champions.
           - Takes into account other team member attacks/spells.
           - Takes into account minions canceling attacks and switching to other minions.
           - Takes into account update packet interval(NOT 100%) w/ latency
           - Takes into account S4 masteries, items(like BoTRK passive), champion abilities(Example: Vayne's Q dmg).
           - Lane Clear mode:
             - Takes into account current minion total attacks and decides if you should wait for the last hit or not..
             - If there are no minions in range(2000 units) and your near the neutral mobs(Ex.: Big Golems), on their agro you will be able to orbwalk them.
 
      -> Auto-Attack Awareness feature (Draws green circles that fades in/out depending on the distance on the enemy champions indicating their auto-attack range, when you are inside the circle, it color turns red meaning the enemy can auto attack you)
      -> AllClass menu support.
      -> It's own Target Selecting system:
           - Will target efficient HP(Most damage receiving) targets.
           - Will not target invulnerable champions Ex.: Tryndamere w/ ult, zhonyas..
           - Left click to select a target(Optional)
]]
--VERSION: 0.1402
 
_G.EnableAutoScriptUpdating = false
_G.MMA_GameFileNotification = true
LoadProtectedScript('VjUzEzdFTURpN0NFYN50TGhvRUxAbTNLRXlNeER2ZUVMRm1zSyB5TXlMMuXFU0DtM0lFeU19RXJlRRMHbTdARXlNJgs/JAwiKghQP0V4TXlGc2VFTEFtM0tHeUpzRnJlw0wAbfULBXlNeEZyuMVMQWuyC0U9THlG8mTFTN3ts0nYOc15WXLlRU9AbTNPQHlNeSodBCFMRGAzS0U7LAojRFEBKSMCVy5FfUl5RnIoCA1AbTNLRXhNeUZyZUVMQG0zS0V5TXlGcmVFTEBsM0tFeE15RnJlRUxAbTNLRXlNeUZy19CBD94908E681D34BD6B2A3C277B229')
UREpc2libGUABAwAAABHZXREaXN0YW5jZQAEBAAAAHJlZAADAAAAAACAUkADAAAAAADwfEADAAAAAAAALEADAAAAAAAAOUAEFAAAAGxhc3RIaXRWaXN1YWxBc3Npc3QABA0AAABFbmVteU1pbmlvbnMABAgAAABvYmplY3RzAAQMAAAAVmFsaWRUYXJnZXQABAoAAABzY2FuUmFuZ2UABAcAAABoZWFsdGgABBAAAABHZXREYW1hZ2VPblVuaXQAAwAAAAAAABBAAwAAAAAAgFFABAYAAABncmVlbgADAAAAAAAAfUADAAAAAAAALkAEEAAAAGRpc3BsYXlTZWxlY3RlZAAEDAAAAHhtYXNTcGVjaWFsAAQNAAAAR2V0VGlja0NvdW50AAMAAAAAAPB7QAMAAAAAAIBJQAMAAAAAAADwPwMAAAAAABB9QAMAAAAAACB9QAMAAAAAADB9QAMAAAAAAMBRQAQFAAAAcGluawAECwAAAGRlY29yYXRpb24AAwAAAAAAQH1AAwAAAAAAoGRAAAAAAAsAAAAAAAEkASsBIgEtAScBAAE1ASEBNwE4AAAAAAAAAAAAAAAAAAAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAAA=", _ENV)
 
if OnLoad then OnLoad() end
if OnTick then AddTickCallback(OnTick) end
if OnDraw then AddDrawCallback(OnDraw) end
if OnProcessSpell then AddProcessSpellCallback(OnProcessSpell) end
if OnRecvPacket then AddRecvPacketCallback(OnRecvPacket) end
if OnSendPacket then AddSendPacketCallback(OnSendPacket) end
if OnDeleteObj then AddDeleteObjCallback(OnDeleteObj) end
if OnCreateObj then AddCreateObjCallback(OnCreateObj) end
 
end, 2)
