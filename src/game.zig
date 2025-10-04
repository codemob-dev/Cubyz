const std = @import("std");
const Atomic = std.atomic.Value;

const assets = @import("assets.zig");
const itemdrop = @import("itemdrop.zig");
const ClientItemDropManager = itemdrop.ClientItemDropManager;
const items = @import("items.zig");
const Inventory = items.Inventory;
const ZonElement = @import("zon.zig").ZonElement;
const main = @import("main");
const network = @import("network.zig");
const particles = @import("particles.zig");
const Connection = network.Connection;
const ConnectionManager = network.ConnectionManager;
const vec = @import("vec.zig");
const Vec2f = vec.Vec2f;
const Vec3i = vec.Vec3i;
const Vec3f = vec.Vec3f;
const Vec4f = vec.Vec4f;
const Vec3d = vec.Vec3d;
const Mat4f = vec.Mat4f;
const graphics = @import("graphics.zig");
const Fog = graphics.Fog;
const renderer = @import("renderer.zig");
const settings = @import("settings.zig");
const Block = main.blocks.Block;
const physics = main.physics;
const KeyBoard = main.KeyBoard;

const chat = @import("gui/windows/chat.zig");

const script: [1363][]const u8 = .{
"According to all known laws of aviation, there is no way a bee should be able to fly.",
"Its wings are too small to get its fat little body off the ground.",
"The bee, of course, flies anyway because bees don't care what humans think is impossible.",
"Yellow, black. Yellow, black. Yellow, black. Yellow, black.",
"Ooh, black and yellow!",
"Let's shake it up a little.",
"Barry! Breakfast is ready!",
"Coming!",
"Hang on a second.",
"Hello?",
"Barry?",
"Adam?",
"Can you believe this is happening?",
"I can't.",
"I'll pick you up.",
"Looking sharp.",
"Use the stairs, Your father paid good money for those.",
"Sorry. I'm excited.",
"Here's the graduate.",
"We're very proud of you, son.",
"A perfect report card, all B's.",
"Very proud.",
"Ma! I got a thing going here.",
"You got lint on your fuzz.",
"Ow! That's me!",
"Wave to us! We'll be in row 118,000.",
"Bye!",
"Barry, I told you, stop flying in the house!",
"Hey, Adam.",
"Hey, Barry.",
"Is that fuzz gel?",
"A little. Special day, graduation.",
"Never thought I'd make it.",
"Three days grade school, three days high school.",
"Those were awkward.",
"Three days college. I'm glad I took a day and hitchhiked around The Hive.",
"You did come back different.",
"Hi, Barry. Artie, growing a mustache? Looks good.",
"Hear about Frankie?",
"Yeah.",
"You going to the funeral?",
"No, I'm not going.",
"Everybody knows, sting someone, you die.",
"Don't waste it on a squirrel.",
"Such a hothead.",
"I guess he could have just gotten out of the way.",
"I love this incorporating an amusement park into our day.",
"That's why we don't need vacations.",
"Boy, quite a bit of pomp under the circumstances.",
"Well, Adam, today we are men.",
"We are!",
"Bee-men.",
"Amen!",
"Hallelujah!",
"Students, faculty, distinguished bees,",
"please welcome Dean Buzzwell.",
"Welcome, New Hive City graduating class of 9:15.",
"That concludes our ceremonies And begins your career at Honex Industries!",
"Will we pick our job today?",
"I heard it's just orientation.",
"Heads up! Here we go.",
"Keep your hands and antennas inside the tram at all times.",
"Wonder what it'll be like?",
"A little scary.",
"Welcome to Honex, a division of Honesco and a part of the Hexagon Group.",
"This is it!",
"Wow.",
"Wow.",
"We know that you, as a bee, have worked your whole life to get to the point where you can work for your whole life.",
"Honey begins when our valiant Pollen Jocks bring the nectar to The Hive.",
"Our top-secret formula is automatically color-corrected, scent-adjusted and bubble-contoured into this soothing sweet syrup with its distinctive golden glow you know as... Honey!",
"That girl was hot.",
"She's my cousin!",
"She is?",
"Yes, we're all cousins.",
"Right. You're right.",
"At Honex, we constantly strive to improve every aspect of bee existence.",
"These bees are stress-testing a new helmet technology.",
"What do you think he makes?",
"Not enough.",
"Here we have our latest advancement, the Krelman.",
"What does that do?",
"Catches that little strand of honey that hangs after you pour it.",
"Saves us millions.",
"Can anyone work on the Krelman?",
"Of course. Most bee jobs are small ones.",
"But bees know that every small job, if it's done well, means a lot.",
"But choose carefully because you'll stay in the job you pick for the rest of your life.",
"The same job the rest of your life? I didn't know that.",
"What's the difference?",
"You'll be happy to know that bees, as a species, haven't had one day off in 27 million years.",
"So you'll just work us to death?",
"We'll sure try.",
"Wow! That blew my mind!",
"\"What's the difference?\"",
"How can you say that?",
"One job forever?",
"That's an insane choice to have to make.",
"I'm relieved. Now we only have to make one decision in life.",
"But, Adam, how could they never have told us that?",
"Why would you question anything? We're bees.",
"We're the most perfectly functioning society on Earth.",
"You ever think maybe things work a little too well here?",
"Like what? Give me one example.",
"I don't know. But you know what I'm talking about.",
"Please clear the gate. Royal Nectar Force on approach.",
"Wait a second. Check it out.",
"Hey, those are Pollen Jocks!",
"Wow.",
"I've never seen them this close.",
"They know what it's like outside The Hive.",
"Yeah, but some don't come back.",
"Hey, Jocks!",
"Hi, Jocks!",
"You guys did great!",
"You're monsters!",
"You're sky freaks! I love it! I love it!",
"I wonder where they were.",
"I don't know.",
"Their day's not planned.",
"Outside The Hive, flying who knows where, doing who knows what.",
"You can't just decide to be a Pollen Jock. You have to be bred for that.",
"Right.",
"Look. That's more pollen than you and I will see in a lifetime.",
"It's just a status symbol.",
"Bees make too much of it.",
"Perhaps. Unless you're wearing it and the ladies see you wearing it.",
"Those ladies?",
"Aren't they our cousins too?",
"Distant. Distant.",
"Look at these two.",
"Couple of Hive Harrys.",
"Let's have fun with them.",
"It must be dangerous being a Pollen Jock.",
"Yeah. Once a bear pinned me against a mushroom!",
"He had a paw on my throat, and with the other, he was slapping me!",
"Oh, my!",
"I never thought I'd knock him out.",
"What were you doing during this?",
"Trying to alert the authorities.",
"I can autograph that.",
"A little gusty out there today, wasn't it, comrades?",
"Yeah. Gusty.",
"We're hitting a sunflower patch six miles from here tomorrow.",
"Six miles, huh?",
"Barry!",
"A puddle jump for us, but maybe you're not up for it.",
"Maybe I am.",
"You are not!",
"We're going 0900 at J-Gate.",
"What do you think, buzzy-boy?",
"Are you bee enough?",
"I might be. It all depends on what 0900 means.",
"Hey, Honex!",
"Dad, you surprised me.",
"You decide what you're interested in?",
"Well, there's a lot of choices.",
"But you only get one.",
"Do you ever get bored doing the same job every day?",
"Son, let me tell you about stirring.",
"You grab that stick, and you just move it around, and you stir it around.",
"You get yourself into a rhythm.",
"It's a beautiful thing.",
"You know, Dad, the more I think about it,",
"maybe the honey field just isn't right for me.",
"You were thinking of what, making balloon animals?",
"That's a bad job for a guy with a stinger.",
"Janet, your son's not sure he wants to go into honey!",
"Barry, you are so funny sometimes.",
"I'm not trying to be funny.",
"You're not funny! You're going into honey. Our son, the stirrer!",
"You're gonna be a stirrer?",
"No one's listening to me!",
"Wait till you see the sticks I have.",
"I could say anything right now.",
"I'm gonna get an ant tattoo!",
"Let's open some honey and celebrate!",
"Maybe I'll pierce my thorax. Shave my antennae. Shack up with a grasshopper. Get a gold tooth and call everybody \"dawg\"!",
"I'm so proud.",
"We're starting work today!",
"Today's the day.",
"Come on! All the good jobs will be gone.",
"Yeah, right.",
"Pollen counting, stunt bee, pouring, stirrer, front desk, hair removal...",
"Is it still available?",
"Hang on. Two left!",
"One of them's yours! Congratulations!",
"Step to the side.",
"What'd you get?",
"Picking crud out. Stellar!",
"Wow!",
"Couple of newbies?",
"Yes, sir! Our first day! We are ready!",
"Make your choice.",
"You want to go first?",
"No, you go.",
"Oh, my. What's available?",
"Restroom attendant's open, not for the reason you think.",
"Any chance of getting the Krelman?",
"Sure, you're on.",
"I'm sorry, the Krelman just closed out.",
"Wax monkey's always open.",
"The Krelman opened up again.",
"What happened?",
"A bee died. Makes an opening. See? He's dead. Another dead one.",
"Deady. Deadified. Two more dead.",
"Dead from the neck up. Dead from the neck down. That's life!",
"Oh, this is so hard!",
"Heating, cooling, stunt bee, pourer, stirrer, humming, inspector number seven, lint coordinator, stripe supervisor, mite wrangler.",
"Barry, what do you think I should... Barry?",
"Barry!",
"All right, we've got the sunflower patch in quadrant nine...",
"What happened to you?",
"Where are you?",
"I'm going out.",
"Out? Out where?",
"Out there.",
"Oh, no!",
"I have to, before I go to work for the rest of my life.",
"You're gonna die! You're crazy! Hello?",
"Another call coming in.",
"If anyone's feeling brave, there's a Korean deli on 83rd that gets their roses today.",
"Hey, guys.",
"Look at that.",
"Isn't that the kid we saw yesterday?",
"Hold it, son, flight deck's restricted.",
"It's OK, Lou. We're gonna take him up.",
"Really? Feeling lucky, are you?",
"Sign here, here. Just initial that.",
"Thank you.",
"OK.",
"You got a rain advisory today, and as you all know, bees cannot fly in rain.",
"So be careful. As always, watch your brooms, hockey sticks, dogs, birds, bears and bats.",
"Also, I got a couple of reports of root beer being poured on us.",
"Murphy's in a home because of it, babbling like a cicada!",
"That's awful.",
"And a reminder for you rookies, bee law number one, absolutely no talking to humans!",
" All right, launch positions!",
"Buzz, buzz, buzz, buzz! Buzz, buzz, buzz, buzz! Buzz, buzz, buzz, buzz!",
"Black and yellow!",
"Hello!",
"You ready for this, hot shot?",
"Yeah. Yeah, bring it on.",
"Wind, check.",
"Antennae, check.",
"Nectar pack, check.",
"Wings, check.",
"Stinger, check.",
"Scared out of my shorts, check.",
"OK, ladies,",
"let's move it out!",
"Pound those petunias, you striped stem-suckers!",
"All of you, drain those flowers!",
"Wow! I'm out!",
"I can't believe I'm out!",
"So blue.",
"I feel so fast and free!",
"Box kite!",
"Wow!",
"Flowers!",
"This is Blue Leader, We have roses visual.",
"Bring it around 30 degrees and hold.",
"Roses!",
"30 degrees, roger. Bringing it around.",
"Stand to the side, kid.",
"It's got a bit of a kick.",
"That is one nectar collector!",
"Ever see pollination up close?",
"No, sir.",
"I pick up some pollen here, sprinkle it over here. Maybe a dash over there, a pinch on that one.",
"See that? It's a little bit of magic.",
"That's amazing. Why do we do that?",
"That's pollen power. More pollen, more flowers, more nectar, more honey for us.",
"Cool.",
"I'm picking up a lot of bright yellow, Could be daisies, Don't we need those?",
"Copy that visual.",
"Wait. One of these flowers seems to be on the move.",
"Say again? You're reporting a moving flower?",
"Affirmative.",
"That was on the line!",
"This is the coolest. What is it?",
"I don't know, but I'm loving this color.",
"It smells good.",
"Not like a flower, but I like it.",
"Yeah, fuzzy.",
"Chemical-y.",
"Careful, guys. It's a little grabby.",
"My sweet lord of bees!",
"Candy-brain, get off there!",
"Problem!",
"Guys!",
"This could be bad.",
"Affirmative.",
"Very close.",
"Gonna hurt.",
"Mama's little boy.",
"You are way out of position, rookie!",
"Coming in at you like a missile!",
"Help me!",
"I don't think these are flowers.",
"Should we tell him?",
"I think he knows.",
"What is this?!",
"Match point!",
"You can start packing up, honey, because you're about to eat it!",
"Yowser!",
"Gross.",
"There's a bee in the car!",
"Do something!",
"I'm driving!",
"Hi, bee.",
"He's back here!",
"He's going to sting me!",
"Nobody move. If you don't move, he won't sting you. Freeze!",
"He blinked!",
"Spray him, Granny!",
"What are you doing?!",
"Wow... the tension level out here is unbelievable.",
"I gotta get home.",
"Can't fly in rain. Can't fly in rain. Can't fly in rain.",
"Mayday! Mayday! Bee going down!",
"Ken, could you close the window please?",
"Ken, could you close the window please?",
"Check out my new resume. I made it into a fold-out brochure. You see? Folds out.",
"Oh, no. More humans. I don't need this.",
"What was that?",
"Maybe this time. This time. This time. This time! This time! This... Drapes!",
"That is diabolical.",
"It's fantastic. It's got all my special skills, even my top-ten favorite movies.",
"What's number one? Star Wars?",
"Nah, I don't go for that... kind of stuff.",
"No wonder we shouldn't talk to them. They're out of their minds.",
"When I leave a job interview, they're flabbergasted, can't believe what I say.",
"There's the sun. Maybe that's a way out.",
"I don't remember the sun having a big 75 on it.",
"I predicted global warming. I could feel it getting hotter. At first I thought it was just me.",
"Wait! Stop! Bee!",
"Stand back. These are winter boots.",
"Wait!",
"Don't kill him!",
"You know I'm allergic to them! This thing could kill me!",
"Why does his life have less value than yours?",
"Why does his life have any less value than mine? Is that your statement?",
"I'm just saying all life has value. You don't know what he's capable of feeling.",
"My brochure!",
"There you go, little guy.",
"I'm not scared of him.It's an allergic thing.",
" Put that on your resume brochure.",
"My whole face could puff up.",
"Make it one of your special skills.",
"Knocking someone out is also a special skill.",
"Right. Bye, Vanessa. Thanks.",
"Vanessa, next week? Yogurt night?",
"Sure, Ken. You know, whatever.",
"You could put carob chips on there.",
"Bye.",
"Supposed to be less calories.",
"Bye.",
"I gotta say something. She saved my life. I gotta say something.",
"All right, here it goes.",
"Nah.",
"What would I say?",
"I could really get in trouble. It's a bee law. You're not supposed to talk to a human.",
"I can't believe I'm doing this. I've got to.",
"Oh, I can't do it. Come on!",
"No. Yes. No. Do it. I can't.",
"How should I start it? \"You like jazz?\" No, that's no good.",
"Here she comes! Speak, you fool!",
"Hi!",
"I'm sorry. You're talking.",
"Yes, I know.",
"You're talking!",
"I'm so sorry.",
"No, it's OK. It's fine.",
"I know I'm dreaming. But I don't recall going to bed.",
"Well, I'm sure this is very disconcerting.",
"This is a bit of a surprise to me. I mean, you're a bee!",
"I am. And I'm not supposed to be doing this, but they were all trying to kill me.",
"And if it wasn't for you... I had to thank you. It's just how I was raised.",
"That was a little weird. I'm talking with a bee.",
"Yeah.",
"I'm talking to a bee. And the bee is talking to me!",
"I just want to say I'm grateful.",
"I'll leave now.",
"Wait! How did you learn to do that?",
"What?",
"The talking thing.",
"Same way you did, I guess. \"Mama, Dada, honey.\" You pick it up.",
"That's very funny.",
"Yeah.",
"Bees are funny. If we didn't laugh, we'd cry with what we have to deal with.",
"Anyway... Can I... get you something?",
"Like what?",
"I don't know. I mean... I don't know. Coffee?",
"I don't want to put you out.",
"It's no trouble. It takes two minutes.",
"It's just coffee.",
"I hate to impose.",
"Don't be ridiculous!",
"Actually, I would love a cup.",
"Hey, you want rum cake?",
"I shouldn't.",
"Have some.",
"No, I can't.",
"Come on!",
"I'm trying to lose a couple micrograms.",
"Where?",
"These stripes don't help.",
"You look great!",
"I don't know if you know anything about fashion.",
"Are you all right?",
"No.",
"He's making the tie in the cab as they're flying up Madison.",
"He finally gets there.",
"He runs up the steps into the church.",
"The wedding is on.",
"And he says, \"Watermelon?",
"I thought you said Guatemalan.",
"Why would I marry a watermelon?\"",
"Is that a bee joke?",
"That's the kind of stuff we do.",
"Yeah, different.",
"So, what are you gonna do, Barry?",
"About work? I don't know.",
"I want to do my part for The Hive, but I can't do it the way they want.",
"I know how you feel.",
"You do?",
"Sure.",
"My parents wanted me to be a lawyer or a doctor, but I wanted to be a florist.",
"Really?",
"My only interest is flowers.",
"Our new queen was just elected with that same campaign slogan.",
"Anyway, if you look... There's my hive right there. See it?",
"You're in Sheep Meadow!",
"Yes! I'm right off the Turtle Pond!",
"No way! I know that area. I lost a toe ring there once.",
"Why do girls put rings on their toes?",
"Why not?",
"It's like putting a hat on your knee.",
"Maybe I'll try that.",
"You all right, ma'am?",
"Oh, yeah. Fine.",
"Just having two cups of coffee!",
"Anyway, this has been great.",
"Thanks for the coffee.",
"Yeah, it's no trouble.",
"Sorry I couldn't finish it. If I did, I'd be up the rest of my life.",
"Are you...?",
"Can I take a piece of this with me?",
"Sure! Here, have a crumb.",
"Thanks!",
"Yeah.",
"All right. Well, then... I guess I'll see you around. Or not.",
"OK, Barry.",
"And thank you so much again... for before.",
"Oh, that? That was nothing.",
"Well, not nothing, but... Anyway...",
"This can't possibly work.",
"He's all set to go.",
"We may as well try it.",
"OK, Dave, pull the chute.",
"Sounds amazing.",
"It was amazing!",
"It was the scariest, happiest moment of my life.",
"Humans! I can't believe you were with humans!",
"Giant, scary humans!",
"What were they like?",
"Huge and crazy. They talk crazy.",
"They eat crazy giant things.",
"They drive crazy.",
"Do they try and kill you, like on TV?",
"Some of them. But some of them don't.",
"How'd you get back?",
"Poodle.",
"You did it, and I'm glad. You saw whatever you wanted to see.",
"You had your \"experience.\" Now you can pick out yourjob and be normal.",
"Well...",
"Well?",
"Well, I met someone.",
"You did? Was she Bee-ish?",
"A wasp?! Your parents will kill you!",
"No, no, no, not a wasp.",
"Spider?",
"I'm not attracted to spiders.",
"I know it's the hottest thing, with the eight legs and all. I can't get by that face.",
"So who is she?",
"She's... human.",
"No, no. That's a bee law. You wouldn't break a bee law.",
"Her name's Vanessa.",
"Oh, boy.",
"She's so nice. And she's a florist!",
"Oh, no! You're dating a human florist!",
"We're not dating.",
"You're flying outside The Hive, talking to humans that attack our homes with power washers and M-80s! One-eighth a stick of dynamite!",
"She saved my life! And she understands me.",
"This is over!",
"Eat this.",
"This is not over! What was that?",
"They call it a crumb.",
"It was so stingin' stripey!",
"And that's not what they eat.",
"That's what falls off what they eat!",
"You know what a Cinnabon is?",
"No.",
"It's bread and cinnamon and frosting. They heat it up...",
"Sit down!",
"...really hot!",
"Listen to me!",
"We are not them! We're us.",
"There's us and there's them!",
"Yes, but who can deny the heart that is yearning?",
"There's no yearning. Stop yearning. Listen to me!",
"You have got to start thinking bee, my friend. Thinking bee!",
"Thinking bee.",
"Thinking bee.",
"Thinking bee! Thinking bee! Thinking bee! Thinking bee!",
"There he is. He's in the pool.",
"You know what your problem is, Barry?",
"I gotta start thinking bee?",
"How much longer will this go on?",
"It's been three days! Why aren't you working?",
"I've got a lot of big life decisions to think about.",
"What life? You have no life!",
"You have no job. You're barely a bee!",
"Would it kill you to make a little honey?",
"Barry, come out. Your father's talking to you.",
"Martin, would you talk to him?",
"Barry, I'm talking to you!",
"You coming?",
"Got everything?",
"All set!",
"Go ahead. I'll catch up.",
"Don't be too long.",
"Watch this!",
"Vanessa!",
"We're still here.",
"I told you not to yell at him.",
"He doesn't respond to yelling!",
"Then why yell at me?",
"Because you don't listen!",
"I'm not listening to this.",
"Sorry, I've gotta go.",
"Where are you going?",
"I'm meeting a friend.",
"A girl? Is this why you can't decide?",
"Bye.",
"I just hope she's Bee-ish.",
"They have a huge parade of flowers every year in Pasadena?",
"To be in the Tournament of Roses, that's every florist's dream!",
"Up on a float, surrounded by flowers, crowds cheering.",
"A tournament. Do the roses compete in athletic events?",
"No. All right, I've got one.",
"How come you don't fly everywhere?",
"It's exhausting. Why don't you run everywhere? It's faster.",
"Yeah, OK, I see, I see.",
"All right, your turn.",
"TiVo. You can just freeze live TV? That's insane!",
"You don't have that?",
"We have Hivo, but it's a disease. It's a horrible, horrible disease.",
"Oh, my.",
"Dumb bees!",
"You must want to sting all those jerks.",
"We try not to sting. It's usually fatal for us.",
"So you have to watch your temper.",
"Very carefully.",
"You kick a wall, take a walk, write an angry letter and throw it out. Work through it like any emotion: Anger, jealousy, lust.",
"Oh, my goodness! Are you OK?",
"Yeah.",
"What is wrong with you?!",
"It's a bug.",
"He's not bothering anybody.",
"Get out of here, you creep!",
"What was that? A Pic 'N' Save circular?",
"Yeah, it was. How did you know?",
"It felt like about 10 pages. Seventy-five is pretty much our limit.",
"You've really got that down to a science.",
"I lost a cousin to Italian Vogue.",
"I'll bet.",
"What in the name of Mighty Hercules is this?",
"How did this get here? cute Bee, Golden Blossom, Ray Liotta Private Select?",
"Is he that actor?",
"I never heard of him.",
"Why is this here?",
"For people. We eat it.",
"You don't have enough food of your own?",
"Well, yes.",
"How do you get it?",
"Bees make it.",
"I know who makes it! And it's hard to make it!",
"There's heating, cooling, stirring. You need a whole Krelman thing!",
"It's organic.",
"It's our-ganic!",
"It's just honey, Barry.",
"Just what?!",
"Bees don't know about this! This is stealing! A lot of stealing!",
"You've taken our homes, schools,hospitals! This is all we have!",
"And it's on sale?! I'm getting to the bottom of this.",
"I'm getting to the bottom of all of this!",
"Hey, Hector. You almost done?",
"Almost.",
"He is here. I sense it.",
"Well, I guess I'll go home now and just leave this nice honey out, with no one around.",
"You're busted, box boy!",
"I knew I heard something.",
"So you can talk!",
"I can talk. And now you'll start talking!",
"Where you getting the sweet stuff? Who's your supplier?",
"I don't understand.",
"I thought we were friends.",
"The last thing we want to do is upset bees!",
"You're too late! It's ours now!",
"You, sir, have crossed the wrong sword!",
"You, sir, will be lunch for my iguana, Ignacio!",
"Where is the honey coming from? Tell me where!",
"Honey Farms! It comes from Honey Farms!",
"Crazy person!",
"What horrible thing has happened here?",
"These faces, they never knew what hit them. And now",
"they're on the road to nowhere!",
"Just keep still.",
"What? You're not dead?",
"Do I look dead? They will wipe anything that moves. Where you headed?",
"To Honey Farms. I am onto something huge here.",
"I'm going to Alaska. Moose blood, crazy stuff. Blows your head off!",
"I'm going to Tacoma.",
"And you?",
"He really is dead.",
"All right.",
"Uh-oh!",
"What is that?!",
"Oh, no!",
"A wiper! Triple blade!",
"Triple blade?",
"Jump on! It's your only chance, bee!",
"Why does everything have",
"to be so doggone clean?!",
"How much do you people need to see?!",
"Open your eyes!",
"Stick your head out the window!",
"From NPR News in Washington,",
"I'm Carl Kasell.",
"But don't kill no more bugs!",
"Bee!",
"Moose blood guy!!",
"You hear something?",
"Like what?",
"Like tiny screaming.",
"Turn off the radio.",
"Whassup, bee boy?",
"Hey, Blood.",
"Just a row of honey jars, as far as the eye could see.",
"Wow!",
"I assume wherever this truck goes is where they're getting it. I mean, that honey's ours.",
"Bees hang tight. We're all jammed in.",
"It's a close community.",
"Not us, man. We on our own. Every mosquito on his own.",
"What if you get in trouble?",
"You a mosquito, you in trouble. Nobody likes us. They just smack. See a mosquito, smack, smack!",
"At least you're out in the world. You must meet girls.",
"Mosquito girls try to trade up, get with a moth, dragonfly. Mosquito girl don't want no mosquito.",
"You got to be kidding me!",
"Mooseblood's about to leave the building! So long, bee!",
"Hey, guys!",
"Mooseblood!",
"I knew I'd catch y'all down here.",
"Did you bring your crazy straw?",
"We throw it in jars, slap a label on it, and it's pretty much pure profit.",
"What is this place?",
"A bee's got a brain the size of a pinhead.",
"They are pinheads!",
"Pinhead.",
"Check out the new smoker.",
"Oh, sweet. That's the one you want. The Thomas 3000!",
"Smoker?",
"Ninety puffs a minute, semi-automatic. Twice the nicotine, all the tar. A couple breaths of this knocks them right out.",
"They make the honey, and we make the money.",
"\"They make the honey, and we make the money\"?",
"Oh, my!",
"What's going on? Are you OK?",
"Yeah. It doesn't last too long.",
"Do you know you're in a fake hive with fake walls?",
"Our queen was moved here. We had no choice.",
"This is your queen? That's a man in women's clothes! That's a drag queen!",
"What is this?",
"Oh, no!",
"There's hundreds of them!",
"Bee honey.",
"Our honey is being brazenly stolen on a massive scale!",
"This is worse than anything bears have done! I intend to do something.",
"Oh, Barry, stop.",
"Who told you humans are taking our honey? That's a rumor.",
"Do these look like rumors?",
"That's a conspiracy theory. These are obviously doctored photos. How did you get mixed up in this?",
"He's been talking to humans.",
"What? Talking to humans?!",
"He has a human girlfriend. And they make out!",
"Make out? Barry!",
"We do not.",
"You wish you could.",
"Whose side are you on?",
"The bees!",
"I dated a cricket once in San Antonio. Those crazy legs kept me up all night.",
"Barry, this is what you want to do with your life?",
"I want to do it for all our lives. Nobody works harder than bees!",
"Dad, I remember you coming home so overworked",
"your hands were still stirring. You couldn't stop.",
"I remember that.",
"What right do they have to our honey?",
"We live on two cups a year. They put it in lip balm for no reason whatsoever!",
"Even if it's true, what can one bee do?",
"Sting them where it really hurts.",
"In the face! The eye!",
"That would hurt.",
"No.",
"Up the nose? That's a killer.",
"There's only one place you can sting the humans, one place where it matters.",
"Hive at Five, The Hive's only full-hour action news source.",
"No more bee beards!",
"With Bob Bumble at the anchor desk. Weather with Storm Stinger. Sports with Buzz Larvi. And Jeanette Chung.",
"Good evening. I'm Bob Bumble.",
"And I'm Jeanette Ohung.",
"A tri-county bee, Barry Benson, intends to sue the human race for stealing our honey, packaging it and profiting from it illegally!",
"Tomorrow night on Bee Larry King, we'll have three former queens here in our studio, discussing their new book, classy Ladies, out this week on Hexagon.",
"Tonight we're talking to Barry Benson.",
"Did you ever think, \"I'm a kid from The Hive. I can't do this\"?",
"Bees have never been afraid to change the world.",
"What about Bee Oolumbus? Bee Gandhi? Bejesus?",
"Where I'm from, we'd never sue humans.",
"We were thinking of stickball or candy stores.",
"How old are you?",
"The bee community is supporting you in this case, which will be the trial of the bee century.",
"You know, they have a Larry King in the human world too.",
"It's a common name. Next week...",
"He looks like you and has a show and suspenders and colored dots...",
"Next week...",
"Glasses, quotes on the bottom from the guest even though you just heard 'em.",
"Bear Week next week! They're scary, hairy and here live.",
"Always leans forward, pointy shoulders, squinty eyes, very Jewish.",
"In tennis, you attack at the point of weakness!",
"It was my grandmother, Ken. She's 81.",
"Honey, her backhand's a joke!",
"I'm not gonna take advantage of that?",
"Quiet, please.",
"Actual work going on here.",
"Is that that same bee?",
"Yes, it is!",
"I'm helping him sue the human race.",
"Hello.",
"Hello, bee.",
"This is Ken.",
"Yeah, I remember you. Timberland, size ten and a half. Vibram sole, I believe.",
"Why does he talk again?",
"Listen, you better go 'cause we're really busy working.",
"But it's our yogurt night!",
"Bye-bye.",
"Why is yogurt night so difficult?!",
"You poor thing. You two have been at this for hours!",
"Yes, and Adam here has been a huge help.",
"Frosting...",
"How many sugars?",
"Just one. I try not to use the competition.",
"So why are you helping me?",
"Bees have good qualities. And it takes my mind off the shop. Instead of flowers, people are giving balloon bouquets now.",
"Those are great, if you're three.",
"And artificial flowers.",
"Oh, those just get me psychotic!",
"Yeah, me too.",
"Bent stingers, pointless pollination.",
"Bees must hate those fake things!",
"Nothing worse than a daffodil that's had work done.",
"Maybe this could make up for it a little bit.",
"This lawsuit's a pretty big deal.",
"I guess.",
"You sure you want to go through with it?",
"Am I sure? When I'm done with the humans, they won't be able to say, \"Honey, I'm home,\" without paying a royalty!",
"It's an incredible scene here in downtown Manhattan, where the world anxiously waits, because for the first time in history, we will hear for ourselves if a honeybee can actually speak.",
"What have we gotten into here, Barry?",
"It's pretty big, isn't it?",
"I can't believe how many humans don't work during the day.",
"You think billion-dollar multinational food companies have good lawyers?",
"Everybody needs to stay behind the barricade.",
"What's the matter?",
"I don't know, I just got a chill.",
"Well, if it isn't the bee team.",
"You boys work on this?",
"All rise! The Honorable Judge Bumbleton presiding.",
"All right. Case number 4475,",
"Superior Court of New York,",
"Barry Bee Benson v. the Honey Industry is now in session.",
"Mr. Montgomery, you're representing the five food companies collectively?",
"A privilege.",
"Mr. Benson... you're representing all the bees of the world?",
"I'm kidding. Yes, Your Honor, we're ready to proceed.",
"Mr. Montgomery, your opening statement, please.",
"Ladies and gentlemen of the jury, my grandmother was a simple woman. Born on a farm, she believed it was man's divine right to benefit from the bounty of nature God put before us.",
"If we lived in the topsy-turvy world Mr. Benson imagines, just think of what would it mean.",
"I would have to negotiate with the silkworm for the elastic in my britches!",
"Talking bee!",
"How do we know this isn't some sort of holographic motion-picture-capture Hollywood wizardry?",
"They could be using laser beams! Robotics! Ventriloquism! Cloning! For all we know, he could be on steroids!",
"Mr. Benson?",
"Ladies and gentlemen, there's no trickery here. I'm just an ordinary bee. Honey's pretty important to me. It's important to all bees. We invented it! We make it. And we protect it with our lives.",
"Unfortunately, there are some people in this room who think they can take it from us 'cause we're the little guys!",
"I'm hoping that, after this is all over, you'll see how, by taking our honey, you not only take everything we have but everything we are!",
"I wish he'd dress like that all the time. So nice!",
"Call your first witness.",
"So, Mr. Klauss Vanderhayden of Honey Farms, big company you have.",
"I suppose so.",
"I see you also own Honeyburton and Honron!",
"Yes, they provide beekeepers for our farms.",
"Beekeeper. I find that to be a very disturbing term.",
"I don't imagine you employ any bee-free-ers, do you?",
"No.",
"I couldn't hear you.",
"No.",
"No. Because you don't free bees. You keep bees. Not only that, it seems you thought a bear would be an appropriate image for a jar of honey.",
"They're very lovable creatures. Yogi Bear, Fozzie Bear, Build-A-Bear.",
"You mean like this?",
"Bears kill bees!",
"How'd you like his head crashing through your living room?! Biting into your couch! Spitting out your throw pillows! OK, that's enough. Take him away.",
"So, Mr. Sting, thank you for being here. Your name intrigues me. Where have I heard it before?",
"I was with a band called The Police.",
"But you've never been a police officer, have you?",
"No, I haven't.",
"No, you haven't. And so here we have yet another example of bee culture casually stolen by a human for nothing more than a prance-about stage name.",
"Oh, please.",
"Have you ever been stung, Mr. Sting? Because I'm feeling a little stung, Sting. Or should I say... Mr. Gordon M. Sumner!",
"That's not his real name?! You idiots!",
"Mr. Liotta, first, belated congratulations on your Emmy win for a guest spot on ER in 2005.",
"Thank you. Thank you.",
"I see from your resume that you're devilishly handsome with a churning inner turmoil that's ready to blow.",
"I enjoy what I do. Is that a crime?",
"Not yet it isn't. But is this what it's come to for you? Exploiting tiny, helpless bees so you don't have to rehearse your part and learn your lines, sir?",
"Watch it, Benson! I could blow right now!",
"This isn't a goodfella.",
"This is a badfella!",
"Why doesn't someone just step on this creep, and we can all go home?!",
"Order in this court!",
"You're all thinking it!",
"Order! Order, I say!",
"Say it!",
"Mr. Liotta, please sit down!",
"I think it was awfully nice of that bear to pitch in like that. I think the jury's on our side.",
"Are we doing everything right, legally?",
"I'm a florist.",
"Right. Well, here's to a great team.",
"To a great team!",
"Well, hello.",
"Ken!",
"Hello.",
"I didn't think you were coming.",
"No, I was just late I tried to call, but... the battery.",
"I didn't want all this to go to waste,",
"so I called Barry. Luckily, he was free.",
"Oh, that was lucky.",
"There's a little left. I could heat it up.",
"Yeah, heat it up, sure, whatever.",
"So I hear you're quite a tennis player. I'm not much for the game myself. The ball's a little grabby.",
"That's where I usually sit. Right... there.",
"Ken, Barry was looking at your resume, and he agreed with me that eating with chopsticks isn't really a special skill.",
"You think I don't see what you're doing?",
"I know how hard it is to find the right job. We have that in common.",
"Do we?",
"Bees have 100 percent employment, but we do jobs like taking the crud out.",
"That's just what I was thinking about doing.",
"Ken, I let Barry borrow your razor for his fuzz. I hope that was all right.",
"I'm going to drain the old stinger.",
"Yeah, you do that.",
"Look at that.",
"You know, I've just about had it with your little Mind Games.",
"What's that?",
"Italian Vogue.",
"Mamma mia, that's a lot of pages.",
"A lot of ads.",
"Remember what Van said, why is your life more valuable than mine?",
"Funny, I just can't seem to recall that! I think something stinks in here!",
"I love the smell of flowers.",
"How do you like the smell of flames?!",
"Not as much.",
"Water bug! Not taking sides!",
"Ken, I'm wearing a Chapstick hat!",
"This is pathetic!",
"I've got issues!",
"Well, well, well, a royal flush!",
"You're bluffing.",
"Am I?",
"Surf's up, dude!",
"Poo water!",
"That bowl is gnarly. Except for those dirty yellow rings!",
"Kenneth! What are you doing?!",
"You know, I don't even like honey! I don't eat it!",
"We need to talk! He's just a little bee!",
"And he happens to be the nicest bee I've met in a long time!",
"Long time? What are you talking about?! Are there other bugs in your life?",
" No, but there are other things bugging me in life. And you're one of them!",
"Fine! Talking bees, no yogurt night...",
"My nerves are fried from riding on this emotional roller coaster!",
"Goodbye, Ken.",
"And for your information, I prefer sugar-free, artificial sweeteners made by man!",
"I'm sorry about all that.",
"I know it's got an aftertaste! I like it!",
"I always felt there was some kind of barrier between Ken and me. I couldn't overcome it.",
"Oh, well.",
"Are you OK for the trial?",
"I believe Mr. Montgomery is about out of ideas.",
"We would like to call Mr. Barry Benson Bee to the stand.",
"Good idea! You can really see why he's considered one of the best lawyers...",
"Yeah.",
"Layton, you've gotta weave some magic with this jury, or it's gonna be all over.",
"Don't worry. The only thing I have to do to turn this jury around is to remind them of what they don't like about bees.",
"You got the tweezers?",
"Are you allergic?",
"Only to losing, son. Only to losing.",
"Mr. Benson Bee, I'll ask you what I think we'd all like to know.",
"What exactly is your relationship to that woman?",
"We're friends.",
"Good friends?",
"Yes.",
"How good? Do you live together?",
"Wait a minute... Are you her little... bedbug?",
"I've seen a bee documentary or two. From what I understand, doesn't your queen give birth to all the bee children?",
"Yeah, but...",
"So those aren't your real parents!",
"Oh, Barry...",
"Yes, they are!",
"Hold me back!",
"You're an illegitimate bee, aren't you, Benson?",
"He's denouncing bees!",
"Don't y'all date your cousins?",
"Objection!",
"I'm going to pincushion this guy!",
"Adam, don't! It's what he wants!",
"Oh, I'm hit!! Oh, lordy, I am hit!",
"Order! Order!",
"The venom! The venom is coursing through my veins! I have been felled by a winged beast of destruction! You see? You can't treat them like equals! They're striped savages! Stinging's the only thing they know! It's their way!",
"Adam, stay with me.",
"I can't feel my legs.",
"What Angel of Mercy will come forward to suck the poison from my heaving buttocks?",
"I will have order in this court. Order! Order, please!",
"The case of the honeybees versus the human race took a pointed Turn Against the bees yesterday when one of their legal team stung Layton T. Montgomery.",
"Hey, buddy.",
"Hey.",
"Is there much pain?",
"Yeah.",
"I... I blew the whole case, didn't I?",
"It doesn't matter. What matters is",
"you're alive. You could have died.",
"I'd be better off dead. Look at me.",
"They got it from the cafeteria downstairs, in a tuna sandwich. Look, there's a little celery still on it.",
"What was it like to sting someone?",
"I can't explain it. It was all... All adrenaline and then...and then ecstasy!",
"All right.",
"You think it was all a trap?",
"Of course. I'm sorry. I flew us right into this.",
"What were we thinking? Look at us. We're just a couple of bugs in this world.",
"What will the humans do to us if they win?",
"I don't know.",
"I hear they put the roaches in motels. That doesn't sound so bad.",
"Adam, they check in, but they don't check out!",
"Oh, my.",
"Could you get a nurse to close that window?",
"Why?",
"The smoke.",
"Bees don't smoke.",
"Right. Bees don't smoke.",
"Bees don't smoke!",
"But some bees are smoking.",
"That's it! That's our case!",
"It is? It's not over?",
"Get dressed. I've gotta go somewhere.",
"Get back to the court and stall. Stall any way you can.",
"And assuming you've done step correctly, you're ready for the tub.",
"Mr. Flayman.",
"Yes? Yes, Your Honor!",
"Where is the rest of your team?",
"Well, Your Honor, it's interesting. Bees are trained to fly haphazardly, and as a result, we don't make very good time.",
"I actually heard a funny story about...",
"Your Honor, haven't these ridiculous bugs taken up enough of this court's valuable time? How much longer will we allow these absurd shenanigans to go on?",
"They have presented no compelling evidence to support their charges against my clients, who run legitimate businesses.",
"I move for a complete dismissal of this entire case!",
"Mr. Flayman, I'm afraid I'm going to have to consider Mr. Montgomery's motion.",
"But you can't! We have a terrific case.",
"Where is your proof?",
"Where is the evidence?",
"Show me the smoking gun!",
"Hold it, Your Honor!",
"You want a smoking gun? Here is your smoking gun.",
"What is that?",
"It's a bee smoker!",
"What, this? This harmless little contraption? This couldn't hurt a fly, let alone a bee.",
"Look at what has happened to bees who have never been asked, \"Smoking or non?\" Is this what nature intended for us? To be forcibly addicted to smoke machines and man-made wooden slat work camps?",
"Living out our lives as honey slaves to the white man?",
"What are we gonna do?",
"He's playing the species card.",
"Ladies and gentlemen, please, free these bees!",
"Free the bees! Free the bees! Free the bees! Free the bees! Free the bees!",
"The court finds in favor of the bees!",
"Vanessa, we won!",
"I knew you could do it! High-five!",
"Sorry.",
"I'm OK! You know what this means?",
"All the honey will finally belong to the bees.",
"Now we won't have to work so hard all the time.",
"This is an unholy perversion of the balance of nature, Benson.",
"You'll regret this.",
"Barry, how much honey is out there?",
"All right. One at a time.",
"Barry, who are you wearing?",
"My sweater is Ralph Lauren, and I have no pants.",
"What if Montgomery's right?",
"What do you mean?",
"We've been living the bee way a long time, 27 million years.",
"Congratulations on your victory. What will you demand as a settlement?",
"First, we'll demand a complete shutdown of all bee work camps.",
"Then we want back the honey that was ours to begin with, every last drop.",
"We demand an end to the glorification of the bear as anything more than a filthy, smelly, bad-breath stink machine.",
"We're all aware of what they do in the woods.",
"Wait for my signal. Take him out.",
"He'll have nauseous for a few hours, then he'll be fine.",
"And we will no longer tolerate bee-negative nicknames...",
"But it's just a prance-about stage name!",
"...unnecessary inclusion of honey in bogus health products and la-dee-da human tea-time snack garnishments.",
"Can't breathe.",
"Bring it in, boys!",
"Hold it right there! Good.",
"Tap it.",
"Mr. Buzzwell, we just passed three cups and there's gallons more coming!",
"I think we need to shut down!",
"Shut down? We've never shut down.",
"Shut down honey production!",
"Stop making honey!",
"Turn your key, sir!",
"What do we do now?",
"Cannonball!",
"We're shutting honey production!",
"Mission abort.",
"Aborting pollination and nectar detail.",
"Returning to base.",
"Adam, you wouldn't believe how much honey was out there.",
"Oh, yeah?",
"What's going on? Where is everybody?",
"Are they out celebrating?",
"They're home.",
"They don't know what to do. Laying out, sleeping in.",
"I heard your Uncle Carl was on his way to San Antonio with a cricket.",
"At least we got our honey back.",
"Sometimes I think, so what if humans liked our honey? Who wouldn't?",
"It's the greatest thing in the world! I was excited to be part of making it.",
"This was my new desk. This was my new job. I wanted to do it really well. And now...",
"Now I can't.",
"I don't understand why they're not happy.",
"I thought their lives would be better!",
"They're doing nothing. It's amazing.",
"Honey really changes people.",
"You don't have any idea what's going on, do you?",
"What did you want to show me?",
"This.",
"What happened here?",
"That is not the half of it.",
"Oh, no. Oh, my.",
"They're all wilting.",
"Doesn't look very good, does it?",
"No.",
"And whose fault do you think that is?",
"You know, I'm gonna guess bees.",
"Bees?",
"Specifically, me.",
"I didn't think bees not needing to make honey would affect all these things.",
"It's not just flowers. Fruits, vegetables, they all need bees.",
"That's our whole SAT test right there.",
"Take away produce, that affects the entire animal kingdom.",
"And then, of course...",
"The human species?",
"So if there's no more pollination, it could all just go south here, couldn't it?",
"I know this is also partly my fault.",
"How about a suicide pact?",
"How do we do it?",
"I'll sting you, you step on me.",
"That just kills you twice.",
"Right, right.",
"Listen, Barry... sorry, but I gotta get going.",
"I had to open my mouth and talk.",
"Vanessa?",
"Vanessa? Why are you leaving?",
"Where are you going?",
"To the final Tournament of Roses parade in Pasadena.",
"They've moved it to this weekend because all the flowers are dying.",
"It's the Last Chance I'll ever have to see it.",
"Vanessa, I just wanna say I'm sorry.",
"I never meant it to turn out like this.",
"I know. Me neither.",
"Tournament of Roses.",
"Roses can't do sports.",
"Wait a minute. Roses. Roses?",
"Roses!",
"Vanessa!",
"Roses?!",
"Barry?",
"Roses are flowers!",
"Yes, they are.",
"Flowers, bees, pollen!",
"I know.",
"That's why this is the last parade.",
"Maybe not.",
"Could you ask him to slow down?",
"Could you slow down?",
"Barry!",
"OK, I made a huge mistake.",
"This is a total disaster, all my fault.",
"Yes, it kind of is.",
"I've ruined the planet. I wanted to help you with the flower shop. I've made it worse.",
"Actually, it's completely closed down.",
"I thought maybe you were remodeling.",
"But I have another idea, and it's greater than my previous ideas combined.",
"I don't want to hear it!",
"All right, they have the roses, the roses have the pollen.",
"I know every bee, plant and flower bud in this park.",
"All we gotta do is get what they've got back here with what we've got.",
"Bees.",
"Park.",
"Pollen!",
"Flowers.",
"Repollination!",
"Across the nation!",
"Tournament of Roses, Pasadena, California.",
"They've got nothing but flowers, floats and cotton candy.",
"Security will be tight.",
"I have an idea.",
"Vanessa Bloome, FTD.",
"Official floral business. It's real.",
"Sorry, ma'am. Nice brooch.",
"Thank you. It was a gift.",
"Once inside, we just pick the right float.",
"How about The Princess and the Pea?",
"I could be the princess, and you could be the pea!",
"Yes, I got it.",
"Where should I sit?",
"What are you?",
"I believe I'm the pea.",
"The pea?",
"It goes under the mattresses.",
"Not in this fairy tale, sweetheart.",
"I'm getting the marshal.",
"You do that! This whole parade is a fiasco!",
"Let's see what this baby'll do.",
"Hey, what are you doing?!",
"Then all we do is blend in with traffic... without arousing suspicion.",
"Once at the airport, there's no stopping us.",
"Stop! Security.",
"You and your insect pack your float?",
"Yes.",
"Has it been in your possession the entire time?",
"Would you remove your shoes?",
"Remove your stinger.",
"It's part of me.",
"I know. Just having some fun.",
"Enjoy your flight.",
"Then if we're lucky, we'll have just enough pollen to do the job.",
"Can you believe how lucky we are? We have just enough pollen to do the job!",
"I think this is gonna work.",
"It's got to work.",
"Attention, passengers, this is Captain Scott. We have a bit of bad weather in New York. It looks like we'll experience a couple hours delay.",
"Barry, these are cut flowers with no water. They'll never make it.",
"I gotta get up there and talk to them.",
"Be careful.",
"Can I get help with the Sky Mall magazine? I'd like to order the talking inflatable nose and ear hair trimmer.",
"Captain, I'm in a real situation.",
"What'd you say, Hal?",
"Nothing.",
"Bee!",
"Don't freak out! My entire species...",
"What are you doing?",
"Wait a minute! I'm an attorney!",
"Who's an attorney?",
"Don't move.",
"Oh, Barry.",
"Good afternoon, passengers. This is your captain. Would a Miss Vanessa Bloome in 24B please report to the cockpit? And please hurry!",
"What happened here?",
"There was a DustBuster, a toupee, a life raft exploded.",
"One's bald, one's in a boat, they're both unconscious!",
"Is that another bee joke?",
"No!",
"No one's flying the plane!",
"This is JFK control tower, Flight 356. What's your status?",
"This is Vanessa Bloome. I'm a florist from New York.",
"Where's the pilot?",
"He's unconscious, and so is the copilot.",
"Not good. Does anyone onboard have flight experience?",
"As a matter of fact, there is.",
"Who's that?",
"Barry Benson.",
"From the honey trial?! Oh, great.",
"Vanessa, this is nothing more than a big metal bee.",
"It's got giant wings, huge engines.",
"I can't fly a plane.",
"Why not? Isn't John Travolta a pilot?",
"Yes.",
"How hard could it be?",
"Wait, Barry!",
"We're headed into some lightning.",
"This is Bob Bumble. We have some late-breaking news from JFK Airport, where a suspenseful scene is developing.",
"Barry Benson, fresh from his legal victory...",
"That's Barry!",
"...is attempting to land a plane, loaded with people, flowers and an incapacitated flight crew.",
"Flowers?!",
"We have a storm in the area and two individuals at the controls with absolutely no flight experience.",
"Just a minute. There's a bee on that plane.",
"I'm quite familiar with Mr. Benson and his no-account compadres.",
"They've done enough damage.",
"But isn't he your only hope?",
"Technically, a bee shouldn't be able to fly at all.",
"Their wings are too small... Haven't we heard this a million times?",
"\"The surface area of the wings and body mass make no sense.\"",
"Get this on the air!",
"Got it.",
"Stand by.",
"We're going live.",
"The way we work may be a mystery to you. Making honey takes a lot of bees doing a lot of small jobs.",
"But let me tell you about a small job. If you do it well, it makes a big difference.",
"More than we realized. To us, to everyone.",
"That's why I want to get bees back to working together. That's the bee way! We're not made of Jell-O.",
"We get behind a fellow.",
"Black and yellow!",
"Hello!",
"Left, right, down, hover.",
"Hover?",
"Forget hover.",
"This isn't so hard.",
"Beep-beep! Beep-beep!",
"Barry, what happened?!",
"Wait, I think we were on autopilot the whole time.",
"That may have been helping me.",
"And now we're not!",
"So it turns out I cannot fly a plane.",
"All of you, let's get behind this fellow! Move it out!",
"Move out!",
"Our only chance is if I do what I'd do, you copy me with the wings of the plane!",
"Don't have to yell.",
"I'm not yelling! We're in a lot of trouble.",
"It's very hard to concentrate with that panicky tone in your voice!",
"It's not a tone. I'm panicking!",
"I can't do this!",
"Vanessa, pull yourself together. You have to snap out of it!",
"You snap out of it.",
"You snap out of it.",
"You snap out of it!",
"You snap out of it!",
"You snap out of it!",
"You snap out of it!",
"You snap out of it!",
"You snap out of it!",
"Hold it!",
"Why? Come on, it's my turn.",
"How is the plane flying?",
"I don't know.",
"Hello?",
"Benson, got any flowers for a happy occasion in there?",
"The Pollen Jocks!",
"They do get behind a fellow.",
"Black and yellow.",
"Hello.",
"All right, let's drop this tin can on the blacktop.",
"Where? I can't see anything. Can you?",
"No, nothing. It's all cloudy.",
"Come on. You got to think bee, Barry.",
"Thinking bee.",
"Thinking bee.",
"Thinking bee!",
"Thinking bee! Thinking bee!",
"Wait a minute. I think I'm feeling something.",
"What?",
"I don't know. It's strong, pulling me.",
"Like a 27-million-year-old instinct.",
"Bring the nose down.",
"Thinking bee!",
"Thinking bee! Thinking bee!",
"What in the world is on the tarmac?",
"Get some lights on that!",
"Thinking bee!",
"Thinking bee! Thinking bee!",
"Vanessa, aim for the flower.",
"OK.",
"Cut the engines. We're going in on bee power. Ready, boys?",
"Affirmative!",
"Good. Good. Easy, now. That's it.",
"Land on that flower!",
"Ready? Full reverse!",
"Spin it around!",
"Not that flower! The other one!",
"Which one?",
"That flower.",
"I'm aiming at the flower!",
"That's a fat guy in a flowered shirt.",
"I mean the giant pulsating flower made of millions of bees!",
"Pull forward. Nose down. Tail up.",
"Rotate around it.",
"This is insane, Barry!",
"This's the only way I know how to fly.",
"Am I koo-koo-kachoo, or is this plane flying in an insect-like pattern?",
"Get your nose in there. Don't be afraid. Smell it. Full reverse!",
"Just drop it. Be a part of it.",
"Aim for the center!",
"Now drop it in! Drop it in, woman!",
"Come on, already.",
"Barry, we did it! You taught me how to fly!",
"Yes. No high-five!",
"Right.",
"Barry, it worked!",
"Did you see the giant flower?",
"What giant flower? Where? Of course",
"I saw the flower! That was genius!",
"Thank you.",
"But we're not done yet.",
"Listen, everyone!",
"This runway is covered with the last pollen from the last flowers available anywhere on Earth.",
"That means this is our Last Chance. We're the only ones who make honey, pollinate flowers and dress like this.",
"If we're gonna survive as a species, this is our moment! What do you say?",
"Are we going to be bees, or just Museum of Natural History keychains?",
"We're bees!",
"Keychain!",
"Then follow me! Except Keychain.",
"Hold on, Barry. Here. You've earned this.",
"Yeah!",
"I'm a Pollen Jock! And it's a perfect fit. All I gotta do are the sleeves.",
"Oh, yeah.",
"That's our Barry.",
"Mom! The bees are back!",
"If anybody needs to make a call, now's the time. I got a feeling we'll be working late tonight!",
"Here's your change. Have a great afternoon! Can I help who's next?",
"Would you like some honey with that?",
"It is bee-approved. Don't forget these.",
"Milk, cream, cheese, it's all me.  And I don't see a nickel!",
"Sometimes I just feel like a piece of meat!",
"I had no idea.",
"Barry, I'm sorry.",
"Have you got a moment?",
"Would you excuse me?",
"My mosquito associate will help you.",
"Sorry I'm late.",
"He's a lawyer too?",
"I was already a blood-sucking parasite. All I needed was a briefcase.",
"Have a great afternoon!",
"Barry, I just got this huge tulip order, and I can't get them anywhere.",
"No problem, Vannie. Just leave it to me.",
"You're a lifesaver, Barry. Can I help who's next?",
"All right, scramble, jocks! It's time to fly.",
"Thank you, Barry!",
"That bee is living my life!",
"Let it go, Kenny.",
"When will this nightmare end?!",
"Let it all go.",
"Beautiful day to fly.",
"Sure is.",
"Between you and me,",
"I was dying to get out of that office.",
"You have got to start thinking bee, my friend.",
"Thinking bee!",
"Me?",
"Hold it. Let's just stop for a second. Hold it.",
"I'm sorry. I'm sorry, everyone. Can we stop here?",
"I'm not making a major life decision during a production number!",
"All right. Take ten, everybody. Wrap it up, guys.",
"I had virtually no rehearsal for that."
};

var i: usize = 0;

pub const camera = struct { // MARK: camera
	pub var rotation: Vec3f = Vec3f{0, 0, 0};
	pub var direction: Vec3f = Vec3f{0, 0, 0};
	pub var viewMatrix: Mat4f = Mat4f.identity();
	pub fn moveRotation(mouseX: f32, mouseY: f32) void {
		// Mouse movement along the y-axis rotates the image along the x-axis.
		rotation[0] += mouseY;
		if(rotation[0] > std.math.pi/2.0) {
			rotation[0] = std.math.pi/2.0;
		} else if(rotation[0] < -std.math.pi/2.0) {
			rotation[0] = -std.math.pi/2.0;
		}
		// Mouse movement along the x-axis rotates the image along the z-axis.
		rotation[2] += mouseX;
	}

	pub fn updateViewMatrix() void {
		direction = vec.rotateZ(vec.rotateX(Vec3f{0, 1, 0}, -rotation[0]), -rotation[2]);
		viewMatrix = Mat4f.identity().mul(Mat4f.rotationX(rotation[0])).mul(Mat4f.rotationZ(rotation[2]));
	}
};

pub const collision = struct {
	pub const Box = struct {
		min: Vec3d,
		max: Vec3d,

		pub fn center(self: Box) Vec3d {
			return (self.min + self.max)*@as(Vec3d, @splat(0.5));
		}

		pub fn extent(self: Box) Vec3d {
			return (self.max - self.min)*@as(Vec3d, @splat(0.5));
		}

		pub fn intersects(self: Box, other: Box) bool {
			return @reduce(.And, (self.max > other.min)) and @reduce(.And, (self.min < other.max));
		}
	};

	const Direction = enum(u2) {x = 0, y = 1, z = 2};

	pub fn collideWithBlock(block: main.blocks.Block, x: i32, y: i32, z: i32, entityPosition: Vec3d, entityBoundingBoxExtent: Vec3d, directionVector: Vec3d) ?struct {box: Box, dist: f64} {
		var resultBox: ?Box = null;
		var minDistance: f64 = std.math.floatMax(f64);
		if(block.collide()) {
			const model = block.mode().model(block).model();

			const pos = Vec3d{@floatFromInt(x), @floatFromInt(y), @floatFromInt(z)};
			const entityCollision = Box{.min = entityPosition - entityBoundingBoxExtent, .max = entityPosition + entityBoundingBoxExtent};

			for(model.collision) |relativeBlockCollision| {
				const blockCollision = Box{.min = relativeBlockCollision.min + pos, .max = relativeBlockCollision.max + pos};
				if(blockCollision.intersects(entityCollision)) {
					const dotMin = vec.dot(directionVector, blockCollision.min);
					const dotMax = vec.dot(directionVector, blockCollision.max);

					const distance = @min(dotMin, dotMax);

					if(distance < minDistance) {
						resultBox = blockCollision;
						minDistance = distance;
					} else if(distance == minDistance) {
						resultBox = .{.min = @min(resultBox.?.min, blockCollision.min), .max = @max(resultBox.?.max, blockCollision.max)};
					}
				}
			}
		}
		return .{.box = resultBox orelse return null, .dist = minDistance};
	}

	pub fn collides(comptime side: main.utils.Side, dir: Direction, amount: f64, pos: Vec3d, hitBox: Box) ?Box {
		var boundingBox: Box = .{
			.min = pos + hitBox.min,
			.max = pos + hitBox.max,
		};
		switch(dir) {
			.x => {
				if(amount < 0) boundingBox.min[0] += amount else boundingBox.max[0] += amount;
			},
			.y => {
				if(amount < 0) boundingBox.min[1] += amount else boundingBox.max[1] += amount;
			},
			.z => {
				if(amount < 0) boundingBox.min[2] += amount else boundingBox.max[2] += amount;
			},
		}
		const minX: i32 = @intFromFloat(@floor(boundingBox.min[0]));
		const maxX: i32 = @intFromFloat(@floor(boundingBox.max[0]));
		const minY: i32 = @intFromFloat(@floor(boundingBox.min[1]));
		const maxY: i32 = @intFromFloat(@floor(boundingBox.max[1]));
		const minZ: i32 = @intFromFloat(@floor(boundingBox.min[2]));
		const maxZ: i32 = @intFromFloat(@floor(boundingBox.max[2]));

		const boundingBoxCenter = boundingBox.center();
		const fullBoundingBoxExtent = boundingBox.extent();

		var resultBox: ?Box = null;
		var minDistance: f64 = std.math.floatMax(f64);
		const directionVector: Vec3d = switch(dir) {
			.x => .{-std.math.sign(amount), 0, 0},
			.y => .{0, -std.math.sign(amount), 0},
			.z => .{0, 0, -std.math.sign(amount)},
		};

		var x: i32 = minX;
		while(x <= maxX) : (x += 1) {
			var y: i32 = minY;
			while(y <= maxY) : (y += 1) {
				var z: i32 = maxZ;
				while(z >= minZ) : (z -= 1) {
					const _block = if(side == .client) main.renderer.mesh_storage.getBlockFromRenderThread(x, y, z) else main.server.world.?.getBlock(x, y, z);
					if(_block) |block| {
						if(collideWithBlock(block, x, y, z, boundingBoxCenter, fullBoundingBoxExtent, directionVector)) |res| {
							if(res.dist < minDistance) {
								resultBox = res.box;
								minDistance = res.dist;
							} else if(res.dist == minDistance) {
								resultBox.?.min = @min(resultBox.?.min, res.box.min);
								resultBox.?.max = @min(resultBox.?.max, res.box.max);
							}
						}
					}
				}
			}
		}

		return resultBox;
	}

	const SurfaceProperties = struct {
		friction: f32,
		bounciness: f32,
	};

	pub fn calculateSurfaceProperties(comptime side: main.utils.Side, pos: Vec3d, hitBox: Box, defaultFriction: f32) SurfaceProperties {
		const boundingBox: Box = .{
			.min = pos + hitBox.min,
			.max = pos + hitBox.max,
		};
		const minX: i32 = @intFromFloat(@floor(boundingBox.min[0]));
		const maxX: i32 = @intFromFloat(@floor(boundingBox.max[0]));
		const minY: i32 = @intFromFloat(@floor(boundingBox.min[1]));
		const maxY: i32 = @intFromFloat(@floor(boundingBox.max[1]));

		const z: i32 = @intFromFloat(@floor(boundingBox.min[2] - 0.01));

		var friction: f64 = 0;
		var bounciness: f64 = 0;
		var totalArea: f64 = 0;

		var x = minX;
		while(x <= maxX) : (x += 1) {
			var y = minY;
			while(y <= maxY) : (y += 1) {
				const _block = if(side == .client) main.renderer.mesh_storage.getBlockFromRenderThread(x, y, z) else main.server.world.?.getBlock(x, y, z);

				if(_block) |block| {
					const blockPos: Vec3d = .{@floatFromInt(x), @floatFromInt(y), @floatFromInt(z)};

					const blockBox: Box = .{
						.min = blockPos + @as(Vec3d, @floatCast(block.mode().model(block).model().min)),
						.max = blockPos + @as(Vec3d, @floatCast(block.mode().model(block).model().max)),
					};

					if(boundingBox.min[2] > blockBox.max[2] or boundingBox.max[2] < blockBox.min[2]) {
						continue;
					}

					const max = std.math.clamp(vec.xy(blockBox.max), vec.xy(boundingBox.min), vec.xy(boundingBox.max));
					const min = std.math.clamp(vec.xy(blockBox.min), vec.xy(boundingBox.min), vec.xy(boundingBox.max));

					const area = (max[0] - min[0])*(max[1] - min[1]);

					if(block.collide()) {
						totalArea += area;
						friction += area*@as(f64, @floatCast(block.friction()));
						bounciness += area*@as(f64, @floatCast(block.bounciness()));
					}
				}
			}
		}

		if(totalArea == 0) {
			friction = defaultFriction;
			bounciness = 0.0;
		} else {
			friction = friction/totalArea;
			bounciness = bounciness/totalArea;
		}

		return .{
			.friction = @floatCast(friction),
			.bounciness = @floatCast(bounciness),
		};
	}

	const VolumeProperties = struct {
		terminalVelocity: f64,
		density: f64,
		maxDensity: f64,
		mobility: f64,
	};

	fn overlapVolume(a: Box, b: Box) f64 {
		const min = @max(a.min, b.min);
		const max = @min(a.max, b.max);
		if(@reduce(.Or, min >= max)) return 0;
		return @reduce(.Mul, max - min);
	}

	pub fn calculateVolumeProperties(comptime side: main.utils.Side, pos: Vec3d, hitBox: Box, defaults: VolumeProperties) VolumeProperties {
		const boundingBox: Box = .{
			.min = pos + hitBox.min,
			.max = pos + hitBox.max,
		};
		const minX: i32 = @intFromFloat(@floor(boundingBox.min[0]));
		const maxX: i32 = @intFromFloat(@floor(boundingBox.max[0]));
		const minY: i32 = @intFromFloat(@floor(boundingBox.min[1]));
		const maxY: i32 = @intFromFloat(@floor(boundingBox.max[1]));
		const minZ: i32 = @intFromFloat(@floor(boundingBox.min[2]));
		const maxZ: i32 = @intFromFloat(@floor(boundingBox.max[2]));

		var invTerminalVelocitySum: f64 = 0;
		var densitySum: f64 = 0;
		var maxDensity: f64 = defaults.maxDensity;
		var mobilitySum: f64 = 0;
		var volumeSum: f64 = 0;

		var x: i32 = minX;
		while(x <= maxX) : (x += 1) {
			var y: i32 = minY;
			while(y <= maxY) : (y += 1) {
				var z: i32 = maxZ;
				while(z >= minZ) : (z -= 1) {
					const _block = if(side == .client) main.renderer.mesh_storage.getBlockFromRenderThread(x, y, z) else main.server.world.?.getBlock(x, y, z);
					const totalBox: Box = .{
						.min = @floatFromInt(Vec3i{x, y, z}),
						.max = @floatFromInt(Vec3i{x + 1, y + 1, z + 1}),
					};
					const gridVolume = overlapVolume(boundingBox, totalBox);
					volumeSum += gridVolume;

					if(_block) |block| {
						const collisionBox: Box = .{ // TODO: Check all AABBs individually
							.min = totalBox.min + main.blocks.meshes.model(block).model().min,
							.max = totalBox.min + main.blocks.meshes.model(block).model().max,
						};
						const filledVolume = @min(gridVolume, overlapVolume(collisionBox, totalBox));
						const emptyVolume = gridVolume - filledVolume;
						invTerminalVelocitySum += emptyVolume/defaults.terminalVelocity;
						densitySum += emptyVolume*defaults.density;
						mobilitySum += emptyVolume*defaults.mobility;
						invTerminalVelocitySum += filledVolume/block.terminalVelocity();
						densitySum += filledVolume*block.density();
						maxDensity = @max(maxDensity, block.density());
						mobilitySum += filledVolume*block.mobility();
					} else {
						invTerminalVelocitySum += gridVolume/defaults.terminalVelocity;
						densitySum += gridVolume*defaults.density;
						mobilitySum += gridVolume*defaults.mobility;
					}
				}
			}
		}

		return .{
			.terminalVelocity = volumeSum/invTerminalVelocitySum,
			.density = densitySum/volumeSum,
			.maxDensity = maxDensity,
			.mobility = mobilitySum/volumeSum,
		};
	}

	pub fn collideOrStep(comptime side: main.utils.Side, comptime dir: Direction, amount: f64, pos: Vec3d, hitBox: Box, steppingHeight: f64) Vec3d {
		const index = @intFromEnum(dir);

		// First argument is amount we end up moving in dir, second argument is how far up we step
		var resultingMovement: Vec3d = .{0, 0, 0};
		resultingMovement[index] = amount;
		var checkPos = pos;
		checkPos[index] += amount;

		if(collision.collides(side, dir, -amount, checkPos, hitBox)) |box| {
			const newFloor = box.max[2] + hitBox.max[2];
			const heightDifference = newFloor - checkPos[2];
			if(heightDifference <= steppingHeight) {
				// If we collide but might be able to step up
				checkPos[2] = newFloor;
				if(collision.collides(side, dir, -amount, checkPos, hitBox) == null) {
					// If there's no new collision then we can execute the step-up
					resultingMovement[2] = heightDifference;
					return resultingMovement;
				}
			}

			// Otherwise move as close to the container as possible
			if(amount < 0) {
				resultingMovement[index] = box.max[index] - hitBox.min[index] - pos[index];
			} else {
				resultingMovement[index] = box.min[index] - hitBox.max[index] - pos[index];
			}
		}

		return resultingMovement;
	}

	fn isBlockIntersecting(block: Block, posX: i32, posY: i32, posZ: i32, center: Vec3d, extent: Vec3d) bool {
		const model = block.mode().model(block).model();
		const position = Vec3d{@floatFromInt(posX), @floatFromInt(posY), @floatFromInt(posZ)};
		const entityBox = Box{.min = center - extent, .max = center + extent};
		for(model.collision) |relativeBlockCollision| {
			const blockBox = Box{.min = position + relativeBlockCollision.min, .max = position + relativeBlockCollision.max};
			if(blockBox.intersects(entityBox)) {
				return true;
			}
		}

		return false;
	}

	pub fn touchBlocks(entity: main.server.Entity, hitBox: Box, side: main.utils.Side) void {
		const boundingBox: Box = .{.min = entity.pos + hitBox.min, .max = entity.pos + hitBox.max};

		const minX: i32 = @intFromFloat(@floor(boundingBox.min[0] - 0.01));
		const maxX: i32 = @intFromFloat(@floor(boundingBox.max[0] + 0.01));
		const minY: i32 = @intFromFloat(@floor(boundingBox.min[1] - 0.01));
		const maxY: i32 = @intFromFloat(@floor(boundingBox.max[1] + 0.01));
		const minZ: i32 = @intFromFloat(@floor(boundingBox.min[2] - 0.01));
		const maxZ: i32 = @intFromFloat(@floor(boundingBox.max[2] + 0.01));

		const center: Vec3d = boundingBox.center();
		const extent: Vec3d = boundingBox.extent();

		const extentX: Vec3d = extent + Vec3d{0.01, -0.01, -0.01};
		const extentY: Vec3d = extent + Vec3d{-0.01, 0.01, -0.01};
		const extentZ: Vec3d = extent + Vec3d{-0.01, -0.01, 0.01};

		var posX: i32 = minX;
		while(posX <= maxX) : (posX += 1) {
			var posY: i32 = minY;
			while(posY <= maxY) : (posY += 1) {
				var posZ: i32 = minZ;
				while(posZ <= maxZ) : (posZ += 1) {
					const block: ?Block =
						if(side == .client) main.renderer.mesh_storage.getBlockFromRenderThread(posX, posY, posZ) else main.server.world.?.getBlock(posX, posY, posZ);
					if(block == null or block.?.touchFunction() == null)
						continue;
					const touchX: bool = isBlockIntersecting(block.?, posX, posY, posZ, center, extentX);
					const touchY: bool = isBlockIntersecting(block.?, posX, posY, posZ, center, extentY);
					const touchZ: bool = isBlockIntersecting(block.?, posX, posY, posZ, center, extentZ);
					if(touchX or touchY or touchZ)
						block.?.touchFunction().?(block.?, entity, posX, posY, posZ, touchX and touchY and touchZ);
				}
			}
		}
	}
};

pub const Gamemode = enum(u8) {survival = 0, creative = 1};

pub const DamageType = enum(u8) {
	heal = 0, // For when you are adding health
	kill = 1,
	fall = 2,

	pub fn sendMessage(self: DamageType, name: []const u8) void {
		switch(self) {
			.heal => main.server.sendMessage("{s}§#ffffff was healed", .{name}),
			.kill => main.server.sendMessage("{s}§#ffffff was killed", .{name}),
			.fall => main.server.sendMessage("{s}§#ffffff died of fall damage", .{name}),
		}
	}
};

pub const Player = struct { // MARK: Player
	pub var super: main.server.Entity = .{};
	pub var eyePos: Vec3d = .{0, 0, 0};
	pub var eyeVel: Vec3d = .{0, 0, 0};
	pub var eyeCoyote: f64 = 0;
	pub var eyeStep: @Vector(3, bool) = .{false, false, false};
	pub var crouching: bool = false;
	pub var id: u32 = 0;
	pub var gamemode: Atomic(Gamemode) = .init(.creative);
	pub var isFlying: Atomic(bool) = .init(false);
	pub var isGhost: Atomic(bool) = .init(false);
	pub var hyperSpeed: Atomic(bool) = .init(false);
	pub var mutex: std.Thread.Mutex = .{};
	pub const inventorySize = 32;
	pub var inventory: Inventory = undefined;
	pub var selectedSlot: u32 = 0;

	pub var selectionPosition1: ?Vec3i = null;
	pub var selectionPosition2: ?Vec3i = null;

	pub var currentFriction: f32 = 0;
	pub var volumeProperties: collision.VolumeProperties = .{.density = 0, .maxDensity = 0, .mobility = 0, .terminalVelocity = 0};

	pub var onGround: bool = false;
	pub var jumpCooldown: f64 = 0;
	pub var jumpCoyote: f64 = 0;
	pub const jumpCooldownConstant = 0.3;
	pub const jumpCoyoteTimeConstant = 0.100;

	pub const standingBoundingBoxExtent: Vec3d = .{0.3, 0.3, 0.9};
	pub const crouchingBoundingBoxExtent: Vec3d = .{0.3, 0.3, 0.725};
	pub var crouchPerc: f32 = 0;

	pub var outerBoundingBoxExtent: Vec3d = standingBoundingBoxExtent;
	pub var outerBoundingBox: collision.Box = .{
		.min = -standingBoundingBoxExtent,
		.max = standingBoundingBoxExtent,
	};
	pub var eyeBox: collision.Box = .{
		.min = -Vec3d{standingBoundingBoxExtent[0]*0.2, standingBoundingBoxExtent[1]*0.2, 0.6},
		.max = Vec3d{standingBoundingBoxExtent[0]*0.2, standingBoundingBoxExtent[1]*0.2, 0.9 - 0.05},
	};
	pub var desiredEyePos: Vec3d = .{0, 0, 1.7 - standingBoundingBoxExtent[2]};
	pub const jumpHeight = 1.25;

	fn loadFrom(zon: ZonElement) void {
		super.loadFrom(zon);
		inventory.loadFromZon(zon.getChild("inventory"));
	}

	pub fn setPosBlocking(newPos: Vec3d) void {
		mutex.lock();
		defer mutex.unlock();
		super.pos = newPos;
	}

	pub fn getPosBlocking() Vec3d {
		mutex.lock();
		defer mutex.unlock();
		return super.pos;
	}

	pub fn getVelBlocking() Vec3d {
		mutex.lock();
		defer mutex.unlock();
		return super.vel;
	}

	pub fn getEyePosBlocking() Vec3d {
		mutex.lock();
		defer mutex.unlock();
		return eyePos + super.pos + desiredEyePos;
	}

	pub fn getEyeVelBlocking() Vec3d {
		mutex.lock();
		defer mutex.unlock();
		return eyeVel;
	}

	pub fn getEyeCoyoteBlocking() f64 {
		mutex.lock();
		defer mutex.unlock();
		return eyeCoyote;
	}

	pub fn getJumpCoyoteBlocking() f64 {
		mutex.lock();
		defer mutex.unlock();
		return jumpCoyote;
	}

	pub fn setGamemode(newGamemode: Gamemode) void {
		gamemode.store(newGamemode, .monotonic);

		if(newGamemode != .creative) {
			isFlying.store(false, .monotonic);
			isGhost.store(false, .monotonic);
			hyperSpeed.store(false, .monotonic);
		}
	}

	pub fn isCreative() bool {
		return gamemode.load(.monotonic) == .creative;
	}

	pub fn isActuallyFlying() bool {
		return isFlying.load(.monotonic) and !isGhost.load(.monotonic);
	}

	pub fn steppingHeight() Vec3d {
		if(onGround) {
			return .{0, 0, 0.6};
		} else {
			return .{0, 0, 0.1};
		}
	}

	pub fn placeBlock() void {
		if(main.renderer.MeshSelection.selectedBlockPos) |blockPos| {
			if(!main.KeyBoard.key("shift").pressed) {
				if(main.renderer.mesh_storage.triggerOnInteractBlockFromRenderThread(blockPos[0], blockPos[1], blockPos[2]) == .handled) return;
			}
			const block = main.renderer.mesh_storage.getBlockFromRenderThread(blockPos[0], blockPos[1], blockPos[2]) orelse main.blocks.Block{.typ = 0, .data = 0};
			const gui = block.gui();
			if(gui.len != 0 and !main.KeyBoard.key("shift").pressed) {
				main.gui.openWindow(gui);
				main.Window.setMouseGrabbed(false);
				return;
			}
		}

		inventory.placeBlock(selectedSlot);
	}

	pub fn kill() void {
		Player.super.pos = world.?.spawn;
		Player.super.vel = .{0, 0, 0};

		Player.super.health = Player.super.maxHealth;
		Player.super.energy = Player.super.maxEnergy;

		Player.eyePos = .{0, 0, 0};
		Player.eyeVel = .{0, 0, 0};
		Player.eyeCoyote = 0;
		Player.jumpCoyote = 0;
		Player.eyeStep = .{false, false, false};
	}

	pub fn breakBlock(deltaTime: f64) void {
		inventory.breakBlock(selectedSlot, deltaTime);
	}

	pub fn acquireSelectedBlock() void {
		if(main.renderer.MeshSelection.selectedBlockPos) |selectedPos| {
			const block = main.renderer.mesh_storage.getBlockFromRenderThread(selectedPos[0], selectedPos[1], selectedPos[2]) orelse return;

			const item: items.Item = for(0..items.itemListSize) |idx| {
				const baseItem: main.items.BaseItemIndex = @enumFromInt(idx);
				if(baseItem.block() == block.typ) {
					break .{.baseItem = baseItem};
				}
			} else return;

			// Check if there is already a slot with that item type
			for(0..12) |slotIdx| {
				if(std.meta.eql(inventory.getItem(slotIdx), item)) {
					if(isCreative()) {
						inventory.fillFromCreative(@intCast(slotIdx), item);
					}
					selectedSlot = @intCast(slotIdx);
					return;
				}
			}

			if(isCreative()) {
				const targetSlot = blk: {
					if(inventory.getItem(selectedSlot) == null) break :blk selectedSlot;
					// Look for an empty slot
					for(0..12) |slotIdx| {
						if(inventory.getItem(slotIdx) == null) {
							break :blk slotIdx;
						}
					}
					break :blk selectedSlot;
				};

				inventory.fillFromCreative(@intCast(targetSlot), item);
				selectedSlot = @intCast(targetSlot);
			}
		}
	}
};

pub const World = struct { // MARK: World
	pub const dayCycle: u63 = 12000; // Length of one in-game day in 100ms. Midnight is at DAY_CYCLE/2. Sunrise and sunset each take about 1/16 of the day. Currently set to 20 minutes

	conn: *Connection,
	manager: *ConnectionManager,
	ambientLight: f32 = 0,
	name: []const u8,
	milliTime: i64,
	gameTime: Atomic(i64) = .init(0),
	spawn: Vec3f = undefined,
	connected: bool = true,
	blockPalette: *assets.Palette = undefined,
	itemPalette: *assets.Palette = undefined,
	toolPalette: *assets.Palette = undefined,
	biomePalette: *assets.Palette = undefined,
	itemDrops: ClientItemDropManager = undefined,
	playerBiome: Atomic(*const main.server.terrain.biomes.Biome) = undefined,

	pub fn init(self: *World, ip: []const u8, manager: *ConnectionManager) !void {
		self.* = .{
			.conn = try Connection.init(manager, ip, null),
			.manager = manager,
			.name = "client",
			.milliTime = std.time.milliTimestamp(),
		};
		errdefer self.conn.deinit();

		self.itemDrops.init(main.globalAllocator);
		errdefer self.itemDrops.deinit();
		try network.Protocols.handShake.clientSide(self.conn, settings.playerName);

		main.Window.setMouseGrabbed(true);

		main.blocks.meshes.generateTextureArray();
		main.particles.ParticleManager.generateTextureArray();
		main.models.uploadModels();
	}

	pub fn deinit(self: *World) void {
		self.conn.deinit();

		self.connected = false;

		// TODO: Close all world related guis.
		main.gui.inventory.deinit();
		main.gui.deinit();
		main.gui.init();
		Player.inventory.deinit(main.globalAllocator);
		main.items.clearRecipeCachedInventories();
		main.items.Inventory.Sync.ClientSide.reset();

		main.threadPool.clear();
		main.entity.ClientEntityManager.clear();
		self.itemDrops.deinit();
		self.blockPalette.deinit();
		self.itemPalette.deinit();
		self.toolPalette.deinit();
		self.biomePalette.deinit();
		self.manager.deinit();
		main.server.stop();
		if(main.server.thread) |serverThread| {
			serverThread.join();
			main.server.thread = null;
		}
		main.threadPool.clear();
		renderer.mesh_storage.deinit();
		renderer.mesh_storage.init();
		assets.unloadAssets();
	}

	pub fn finishHandshake(self: *World, zon: ZonElement) !void {
		// TODO: Consider using a per-world allocator.
		self.blockPalette = try assets.Palette.init(main.globalAllocator, zon.getChild("blockPalette"), "cubyz:air");
		errdefer self.blockPalette.deinit();
		self.biomePalette = try assets.Palette.init(main.globalAllocator, zon.getChild("biomePalette"), null);
		errdefer self.biomePalette.deinit();
		self.itemPalette = try assets.Palette.init(main.globalAllocator, zon.getChild("itemPalette"), null);
		errdefer self.itemPalette.deinit();
		self.toolPalette = try assets.Palette.init(main.globalAllocator, zon.getChild("toolPalette"), null);
		errdefer self.toolPalette.deinit();
		self.spawn = zon.get(Vec3f, "spawn", .{0, 0, 0});

		const path = std.fmt.allocPrint(main.stackAllocator.allocator, "{s}/serverAssets", .{main.files.cubyzDirStr()}) catch unreachable;
		defer main.stackAllocator.free(path);
		try assets.loadWorldAssets(path, self.blockPalette, self.itemPalette, self.toolPalette, self.biomePalette);
		Player.id = zon.get(u32, "player_id", std.math.maxInt(u32));
		Player.inventory = Inventory.init(main.globalAllocator, Player.inventorySize, .normal, .{.playerInventory = Player.id}, .{});
		Player.loadFrom(zon.getChild("player"));
		self.playerBiome = .init(main.server.terrain.biomes.getPlaceholderBiome());
		main.audio.setMusic(self.playerBiome.raw.preferredMusic);
	}

	fn dayNightLightFactor(gameTime: i64) struct {f32, Vec3f} {
		const dayTime = @abs(@mod(gameTime, dayCycle) - dayCycle/2);
		if(dayTime < dayCycle/4 - dayCycle/16) {
			return .{0.1, @splat(0)};
		}
		if(dayTime > dayCycle/4 + dayCycle/16) {
			return .{1, @splat(1)};
		}
		var skyColorFactor: Vec3f = undefined;
		// b:
		if(dayTime > dayCycle/4) {
			skyColorFactor[2] = @as(f32, @floatFromInt(dayTime - dayCycle/4))/@as(f32, @floatFromInt(dayCycle/16));
		} else {
			skyColorFactor[2] = 0;
		}
		// g:
		if(dayTime > dayCycle/4 + dayCycle/32) {
			skyColorFactor[1] = 1;
		} else if(dayTime > dayCycle/4 - dayCycle/32) {
			skyColorFactor[1] = 1 - @as(f32, @floatFromInt(dayCycle/4 + dayCycle/32 - dayTime))/@as(f32, @floatFromInt(dayCycle/16));
		} else {
			skyColorFactor[1] = 0;
		}
		// r:
		if(dayTime > dayCycle/4) {
			skyColorFactor[0] = 1;
		} else {
			skyColorFactor[0] = 1 - @as(f32, @floatFromInt(dayCycle/4 - dayTime))/@as(f32, @floatFromInt(dayCycle/16));
		}

		const ambientLight = 0.1 + 0.9*@as(f32, @floatFromInt(dayTime - (dayCycle/4 - dayCycle/16)))/@as(f32, @floatFromInt(dayCycle/8));
		return .{ambientLight, skyColorFactor};
	}

	pub fn update(self: *World) void {
		const newTime: i64 = std.time.milliTimestamp();
		while(self.milliTime +% 100 -% newTime < 0) {
			self.milliTime +%= 100;
			var curTime = self.gameTime.load(.monotonic);
			while(self.gameTime.cmpxchgWeak(curTime, curTime +% 1, .monotonic, .monotonic)) |actualTime| {
				curTime = actualTime;
			}
		}
		// Ambient light:
		{
			self.ambientLight, const skyColorFactor = dayNightLightFactor(self.gameTime.load(.unordered));
			fog.fogColor = biomeFog.fogColor*skyColorFactor;
			fog.skyColor = biomeFog.skyColor*skyColorFactor;
			fog.density = biomeFog.density;
			fog.fogLower = biomeFog.fogLower;
			fog.fogHigher = biomeFog.fogHigher;
		}
		network.Protocols.playerPosition.send(self.conn, Player.getPosBlocking(), Player.getVelBlocking(), @intCast(newTime & 65535));
	}
};
pub var testWorld: World = undefined; // TODO:
pub var world: ?*World = null;

pub var projectionMatrix: Mat4f = Mat4f.identity();

var biomeFog = Fog{.skyColor = .{0.8, 0.8, 1}, .fogColor = .{0.8, 0.8, 1}, .density = 1.0/15.0/128.0, .fogLower = 100, .fogHigher = 1000};
pub var fog = Fog{.skyColor = .{0.8, 0.8, 1}, .fogColor = .{0.8, 0.8, 1}, .density = 1.0/15.0/128.0, .fogLower = 100, .fogHigher = 1000};

var nextBlockPlaceTime: ?i64 = null;
var nextBlockBreakTime: ?i64 = null;

pub fn pressPlace() void {
	const time = std.time.milliTimestamp();
	nextBlockPlaceTime = time + main.settings.updateRepeatDelay;
	Player.placeBlock();
}

pub fn releasePlace() void {
	nextBlockPlaceTime = null;
}

pub fn pressBreak() void {
	const time = std.time.milliTimestamp();
	nextBlockBreakTime = time + main.settings.updateRepeatDelay;
	Player.breakBlock(0);
}

pub fn releaseBreak() void {
	nextBlockBreakTime = null;
}

pub fn pressAcquireSelectedBlock() void {
	Player.acquireSelectedBlock();
}

pub fn flyToggle() void {
	if(!Player.isCreative()) return;

	const newIsFlying = !Player.isActuallyFlying();

	Player.isFlying.store(newIsFlying, .monotonic);
	Player.isGhost.store(false, .monotonic);
}

pub fn ghostToggle() void {
	if(!Player.isCreative()) return;

	const newIsGhost = !Player.isGhost.load(.monotonic);

	Player.isGhost.store(newIsGhost, .monotonic);
	Player.isFlying.store(newIsGhost, .monotonic);
}

pub fn hyperSpeedToggle() void {
	if(!Player.isCreative()) return;

	Player.hyperSpeed.store(!Player.hyperSpeed.load(.monotonic), .monotonic);
}

pub fn update(deltaTime: f64) void { // MARK: update()
	physics.calculateProperties();
	var acc = Vec3d{0, 0, 0};
	const speedMultiplier: f32 = if(Player.hyperSpeed.load(.monotonic)) 4.0 else 1.0;

	const mobility = if(Player.isFlying.load(.monotonic)) 1.0 else Player.volumeProperties.mobility;
	const density = if(Player.isFlying.load(.monotonic)) 0.0 else Player.volumeProperties.density;
	const maxDensity = if(Player.isFlying.load(.monotonic)) 0.0 else Player.volumeProperties.maxDensity;

	const baseFrictionCoefficient: f32 = Player.currentFriction;
	var jumping = false;
	Player.jumpCooldown -= deltaTime;
	// At equillibrium we want to have dv/dt = a - λv = 0 → a = λ*v
	const fricMul = speedMultiplier*baseFrictionCoefficient*if(Player.isFlying.load(.monotonic)) 1.0 else mobility;

	const horizontalForward = vec.rotateZ(Vec3d{0, 1, 0}, -camera.rotation[2]);
	const forward = vec.normalize(std.math.lerp(horizontalForward, camera.direction, @as(Vec3d, @splat(density/@max(1.0, maxDensity)))));
	const right = Vec3d{-horizontalForward[1], horizontalForward[0], 0};
	var movementDir: Vec3d = .{0, 0, 0};
	var movementSpeed: f64 = 0;

	if(main.Window.grabbed) {
		const walkingSpeed: f64 = if(Player.crouching) 2 else 4;
		if(KeyBoard.key("forward").value > 0.0) {
			if(KeyBoard.key("sprint").pressed and !Player.crouching) {
				if(Player.isGhost.load(.monotonic)) {
					movementSpeed = @max(movementSpeed, 128)*KeyBoard.key("forward").value;
					movementDir += forward*@as(Vec3d, @splat(128*KeyBoard.key("forward").value));
				} else if(Player.isFlying.load(.monotonic)) {
					movementSpeed = @max(movementSpeed, 32)*KeyBoard.key("forward").value;
					movementDir += forward*@as(Vec3d, @splat(32*KeyBoard.key("forward").value));
				} else {
					movementSpeed = @max(movementSpeed, 8)*KeyBoard.key("forward").value;
					movementDir += forward*@as(Vec3d, @splat(8*KeyBoard.key("forward").value));
				}
			} else {
				movementSpeed = @max(movementSpeed, walkingSpeed)*KeyBoard.key("forward").value;
				movementDir += forward*@as(Vec3d, @splat(walkingSpeed*KeyBoard.key("forward").value));
			}
		}
		if(KeyBoard.key("backward").value > 0.0) {
			movementSpeed = @max(movementSpeed, walkingSpeed)*KeyBoard.key("backward").value;
			movementDir += forward*@as(Vec3d, @splat(-walkingSpeed*KeyBoard.key("backward").value));
		}
		if(KeyBoard.key("left").value > 0.0) {
			movementSpeed = @max(movementSpeed, walkingSpeed)*KeyBoard.key("left").value;
			movementDir += right*@as(Vec3d, @splat(walkingSpeed*KeyBoard.key("left").value));
		}
		if(KeyBoard.key("right").value > 0.0) {
			movementSpeed = @max(movementSpeed, walkingSpeed)*KeyBoard.key("right").value;
			movementDir += right*@as(Vec3d, @splat(-walkingSpeed*KeyBoard.key("right").value));
		}
		if(KeyBoard.key("jump").pressed) {
			if(Player.isFlying.load(.monotonic)) {
				if(KeyBoard.key("sprint").pressed) {
					if(Player.isGhost.load(.monotonic)) {
						movementSpeed = @max(movementSpeed, 60);
						movementDir[2] += 60;
					} else {
						movementSpeed = @max(movementSpeed, 25);
						movementDir[2] += 25;
					}
				} else {
					movementSpeed = @max(movementSpeed, 5.5);
					movementDir[2] += 5.5;
				}
			} else if((Player.onGround or Player.jumpCoyote > 0.0) and Player.jumpCooldown <= 0) {
				jumping = true;
				Player.jumpCooldown = Player.jumpCooldownConstant;
				if(!Player.onGround) {
					Player.eyeCoyote = 0;
				}
				Player.jumpCoyote = 0;
			} else if(!KeyBoard.key("fall").pressed) {
				movementSpeed = @max(movementSpeed, walkingSpeed);
				movementDir[2] += walkingSpeed;
			}
		} else {
			Player.jumpCooldown = 0;
		}
		if(KeyBoard.key("fall").pressed) {
			if(Player.isFlying.load(.monotonic)) {
				if(KeyBoard.key("sprint").pressed) {
					if(Player.isGhost.load(.monotonic)) {
						movementSpeed = @max(movementSpeed, 60);
						movementDir[2] -= 60;
					} else {
						movementSpeed = @max(movementSpeed, 25);
						movementDir[2] -= 25;
					}
				} else {
					movementSpeed = @max(movementSpeed, 5.5);
					movementDir[2] -= 5.5;
				}
			} else if(!KeyBoard.key("jump").pressed) {
				movementSpeed = @max(movementSpeed, walkingSpeed);
				movementDir[2] -= walkingSpeed;
			}
			if(i < 1363) {
				particles.ParticleSystem.update(@floatCast(deltaTime));
				chat.input.currentString.replaceRange(0, chat.input.currentString.items.len, script[i]);
				i += 1;
				chat.sendMessage(0);
			}
		}

		if(movementSpeed != 0 and vec.lengthSquare(movementDir) != 0) {
			if(vec.lengthSquare(movementDir) > movementSpeed*movementSpeed) {
				movementDir = vec.normalize(movementDir);
			} else {
				movementDir /= @splat(movementSpeed);
			}
			acc += movementDir*@as(Vec3d, @splat(movementSpeed*fricMul));
		}

		const newSlot: i32 = @as(i32, @intCast(Player.selectedSlot)) -% @as(i32, @intFromFloat(main.Window.scrollOffset));
		Player.selectedSlot = @intCast(@mod(newSlot, 12));
		main.Window.scrollOffset = 0;

		const newPos = Vec2f{
			@floatCast(main.KeyBoard.key("cameraRight").value - main.KeyBoard.key("cameraLeft").value),
			@floatCast(main.KeyBoard.key("cameraDown").value - main.KeyBoard.key("cameraUp").value),
		}*@as(Vec2f, @splat(3.14*settings.controllerSensitivity));
		main.game.camera.moveRotation(newPos[0]/64.0, newPos[1]/64.0);
	}

	if(collision.collides(.client, .x, 0, Player.super.pos + Player.standingBoundingBoxExtent - Player.crouchingBoundingBoxExtent, .{
		.min = -Player.standingBoundingBoxExtent,
		.max = Player.standingBoundingBoxExtent,
	}) == null) {
		Player.crouching = KeyBoard.key("crouch").pressed and !Player.isFlying.load(.monotonic);

		if(Player.onGround) {
			if(Player.crouching) {
				Player.crouchPerc += @floatCast(deltaTime*10);
			} else {
				Player.crouchPerc -= @floatCast(deltaTime*10);
			}
			Player.crouchPerc = std.math.clamp(Player.crouchPerc, 0, 1);
		}

		const smoothPerc = Player.crouchPerc*Player.crouchPerc*(3 - 2*Player.crouchPerc);

		const newOuterBox = (Player.crouchingBoundingBoxExtent - Player.standingBoundingBoxExtent)*@as(Vec3d, @splat(smoothPerc)) + Player.standingBoundingBoxExtent;

		Player.super.pos += newOuterBox - Player.outerBoundingBoxExtent + Vec3d{0.0, 0.0, 0.0001*@abs(newOuterBox[2] - Player.outerBoundingBoxExtent[2])};

		Player.outerBoundingBoxExtent = newOuterBox;

		Player.outerBoundingBox = .{
			.min = -Player.outerBoundingBoxExtent,
			.max = Player.outerBoundingBoxExtent,
		};
		Player.eyeBox = .{
			.min = -Vec3d{Player.outerBoundingBoxExtent[0]*0.2, Player.outerBoundingBoxExtent[1]*0.2, Player.outerBoundingBoxExtent[2] - 0.2},
			.max = Vec3d{Player.outerBoundingBoxExtent[0]*0.2, Player.outerBoundingBoxExtent[1]*0.2, Player.outerBoundingBoxExtent[2] - 0.05},
		};
		Player.desiredEyePos = (Vec3d{0, 0, 1.3 - Player.crouchingBoundingBoxExtent[2]} - Vec3d{0, 0, 1.7 - Player.standingBoundingBoxExtent[2]})*@as(Vec3f, @splat(smoothPerc)) + Vec3d{0, 0, 1.7 - Player.standingBoundingBoxExtent[2]};
	}

	physics.update(deltaTime, acc, jumping);

	const time = std.time.milliTimestamp();
	if(nextBlockPlaceTime) |*placeTime| {
		if(time -% placeTime.* >= 0) {
			placeTime.* += main.settings.updateRepeatSpeed;
			Player.placeBlock();
		}
	}
	if(nextBlockBreakTime) |*breakTime| {
		if(time -% breakTime.* >= 0 or !Player.isCreative()) {
			breakTime.* += main.settings.updateRepeatSpeed;
			Player.breakBlock(deltaTime);
		}
	}

	const biome = world.?.playerBiome.load(.monotonic);

	const t = 1 - @as(f32, @floatCast(@exp(-2*deltaTime)));

	biomeFog.fogColor = (biome.fogColor - biomeFog.fogColor)*@as(Vec3f, @splat(t)) + biomeFog.fogColor;
	biomeFog.skyColor = (biome.skyColor - biomeFog.skyColor)*@as(Vec3f, @splat(t)) + biomeFog.skyColor;
	biomeFog.density = (biome.fogDensity - biomeFog.density)*t + biomeFog.density;
	biomeFog.fogLower = (biome.fogLower - biomeFog.fogLower)*t + biomeFog.fogLower;
	biomeFog.fogHigher = (biome.fogHigher - biomeFog.fogHigher)*t + biomeFog.fogHigher;

	world.?.update();
}
