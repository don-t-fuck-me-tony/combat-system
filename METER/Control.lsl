vector ccolor = <1,1,1>;
integer serv_rxchn = -1999999429;
integer serv_txchn = -1999996429;
integer ctrl_chn = 9;
integer chan;
integer colors;
integer mrep;
integer shwstats;
integer menup;
integer menlvl;
integer mentime = 60;
integer lishnd;
integer scn;
integer action;
integer status;
integer lock;
integer experience;
integer maxxp;
integer lvlup;
integer xpticks;
integer level;
integer sex;
integer brsk;
integer intelli;
float intellr;
integer stam;
integer dead;
integer nocomb;
integer racial;
string mctr_psw = "01!hWelcr*dNCSv1.05906";
string serv_psw = "NCSv1.0Murcielago9429!";
string relay_id = "";
string states;
string serv_msg;
string txdata;
string Custom;
string owname;
string stargetn;
string secure;
string prefixurl = "https://ncs-dev.herokuapp.com"; //"https://www.ncs-sl.com";
key serv_id;
key serv_owner;
key owner;
key stargetk;
list grunts = ["e0ab03b3-be70-d582-11c7-aabaab09f632", "4678f128-2d58-1bcb-59e4-224e07364338",
                "8af128a8-593a-0935-42b6-9084a48f6284", "8af128a8-593a-0935-42b6-9084a48f6284"];
list gruntsF = ["a9ba95cd-dcff-5fba-5a6e-9b4edadca596", "a8939844-c39b-fa7c-9472-26e729556518",
                "a8939844-c39b-fa7c-9472-26e729556518", "ecf85e58-5435-4250-c437-3e0bb8e46d85"];
list brskgrnt = ["236aec3a-3812-f962-4eb1-1e9bfa4f053f", "f397e6ba-8ff4-b281-f4e6-b76a9a8e4eb7"
                , "26c8349c-ad60-d60b-0b08-931bd3eacfc1", "ca2d03b5-5446-3f7a-2a27-453bb0b52ab1"
                , "02f207ef-ed4b-2de0-74c8-6781ed75ab01", "4b0d9742-af01-1db5-42f1-73ec90b84cd5"
                , "365b952c-1f6c-740b-5c4f-3b82209158e9", "f52dd374-9a5e-b32f-bc42-185df9381470"
                , "70ba1eaa-7528-b851-e6ef-b231bc6404d5", "3fe79f2f-0cbe-4c4c-6f80-f47a8f7d7f26"
                , "68f7bcf6-ba23-b27d-4f77-d10572544f36", "add6c549-ba1b-e1ad-da7c-b424da678098"
                , "f3f18649-2eca-e4e6-709e-17af90cc83be", "69d2fe1d-d913-62f5-5980-095bed489940"
                , "93d1f777-f2c4-0ae1-5e90-7ad91354ff4b", "5f14f1f7-1cdc-576f-f926-d30f6e6241b6"
                , "42d4c146-ed63-909b-40c0-816e226d6757"];
list targets;
list tarnames;
list gmlist = ["CANCEL", "Kill", "Revive", "Unlock", "Hide", "List", "Lock", "Set NoComb", "Reset", "AllReset", "Detach"];
ini()
{
    owner = llGetOwner();
    owname = llKey2Name(owner);
    colors = 2;brsk = 0;
    llListen(ctrl_chn, owname, owner,"");
    llListen(serv_rxchn, "", "", "");
    text_color();lvlup = 0;
}
gmallreset()
{
    serv_msg = (mctr_psw + "," + (string)owner + "," + "allreset" + "," + (string)owner);
    llRegionSay(serv_rxchn,serv_msg);
}
scan()
{
        targets = [];tarnames = [];
        llSensor("", "", AGENT, 50, PI);
}
findkey()
{
        integer listlen = llGetListLength(tarnames);integer i;for(i = 0; i < listlen; i ++)
        {if(stargetn == llList2String(tarnames, i)){stargetk = llList2Key(targets, i);i = listlen;}}
         txdata += (string)owner;snd_gmcmd();
}
snd_gmcmd()
{
        serv_msg = (mctr_psw + "," + (string)stargetk + "," + txdata);
        llRegionSayTo(stargetk,serv_rxchn,serv_msg);
}
xpinfo()
{
    integer xplevel = (maxxp - experience);integer inlevel = (level + 1);string nlevel = (string)inlevel;
    llOwnerSay("You have " + (string)experience + " XP points and need " + (string)xplevel + " XP to advance to level " + nlevel);
}
levelup()
{
    lvlup = 1;
    llPlaySound("458c9fc0-de07-6a38-8c79-597af7bcd0f9", 1.0);
    llSay(0, "Player " + owname + " Has leveled up!");
    txdata = "NLP";
    llMessageLinked(LINK_THIS, 0, txdata, "Snd_To_Bridge");
    llMessageLinked(LINK_THIS, 0, "booting", "ctrl");
    llSetLinkPrimitiveParamsFast(1,[PRIM_TEXT, "", <0, 0, 0>, 0.0]);
    llMessageLinked(LINK_THIS, 0, "OFF", "ctrl");
    llMessageLinked(LINK_THIS, 0, "leveledup", "controls");
    if(sex == 1){llMessageLinked(LINK_THIS, 0, "hoverm", "controls");}
    else if(sex == 0){llMessageLinked(LINK_THIS, 0, "hoverf", "controls");}
    llMessageLinked(LINK_THIS, 0, "Sec_rq", "Sec_rq");
    key http_request_id;
    string url =  prefixurl + "/relay/api/" + (string)relay_id + "/security/" + (string)owner;
    http_request_id = llHTTPRequest(url, [HTTP_METHOD, "PUT"], (string)owner);
}
lvlup_secure()
{
    string url = prefixurl + "/view/profile/levelup/index.html?uuid=" + (string)owner + "&t=" + secure;
    llLoadURL(owner, "You have Leveled Up!\nGo to NCS website?", url);
}
grunt()
{
        integer value = llRound(llFrand(3));string sound;
        if(sex == 1){sound =  llList2String(grunts,value);}
        else{sound =  llList2String(gruntsF,value);}
        llTriggerSound(sound,1.0);
        if(brsk == 1){berskgrunt();}
}
berskgrunt()
{
    integer bersklislen = llGetListLength(brskgrnt);
    float rnd = llFrand(bersklislen);integer brnd = llFloor(rnd);
    string bsound =  llList2String(brskgrnt,brnd);
    llTriggerSound(bsound,1.0);
}
save_color()
{
    txdata = "Save_Color" + "," + (string)colors;
    llMessageLinked(LINK_THIS, 0, txdata, "Snd_To_Bridge");
}
save_state()
{
    txdata = "Save_State" + "," + (string)states;
    llMessageLinked(LINK_THIS, 0, txdata, "Snd_To_Bridge");
}
text_color()
{
    if(colors == 0){ccolor = <1.000, 1.000, 1.000>;} // White
    else if(colors == 1){ccolor = <1.000, 0.000, 0.000>;} // Red
    else if(colors == 2){ccolor = <0.000, 1.000, 0.000>;} // Green
    else if(colors == 3){ccolor = <0.004, 1.000, 0.439>;} // Lime
    else if(colors == 4){ccolor = <1.000, 0.000, 1.000>;} // Magenta
    else if(colors == 5){ccolor = <0.000, 0.000, 1.000>;} // Blue
    else if(colors == 6){ccolor = <1.000, 1.000, 0.500>;} // Yellow
    else if(colors == 7){ccolor = <0.694, 0.051, 0.788>;} // Purpple
    llMessageLinked(LINK_THIS, 0, (string)ccolor, "M_Display");
}
openlisten()
{
    if(menup == 1){llListenRemove(lishnd);}
    float FloatValue  = 88637 + llFrand(- 15814963);
    chan = llRound(FloatValue);
    lishnd = llListen(chan, "", owner, "");
    menup = 1;
    if(menlvl == 0){llDialog(owner, "NCS GM Control Menu:", gmlist , chan);}
    llSetTimerEvent(mentime);
    if(menlvl == 1){llDialog(owner, "NCS GM Control Targeting:\nChoose a target from the list.", tarnames , chan);}
    llSetTimerEvent(mentime);
}
default
{
    state_entry()
    {
        ini();
    }
    listen(integer chnl, string name, key id, string mesg)
    {
        if(chnl == serv_rxchn) // Boot from local bridge server...
        {
            list data = llCSV2List(mesg);
            string pass = llList2String(data,0);
            key client = (key)llList2String(data,1);
            string msg = llToLower(llList2String(data,2));
            key agent = llList2String(data,3);string gmname = llKey2Name(agent);
        if(pass == mctr_psw)
            {
                if(client == owner)
                {
                if(msg == "reset" && lock == 0){llMessageLinked(LINK_THIS, 0, "Reset_By_GM", "ctrl");
                llSay(0, owname + ": Your Meter has been Reset by GM request! (" + gmname + ")");}
                else if(msg == "unhold" && lock == 1){llMessageLinked(LINK_THIS, 0, "Unlock_By_GM", "ctrl");
                llSay(0, owname + ": Your Meter has been  Enabled by GM! (" + gmname + ")");}
                else if(msg == "live" && dead == 1 && lock == 0){llMessageLinked(LINK_THIS, 0, "Revived_By_GM", "ctrl");
                llSay(0, owname + ": You have been revived by GM! (" + gmname + ")");}
                else if(msg == "off" && lock == 0){llMessageLinked(LINK_THIS, 0, "Off_By_GM", "ctrl");
                llSay(0, owname + ": Your Meter has been forced Off by GM! (" + gmname + ")");}
                //-------------------------------------------------------------------------------
                if(status != 6){
                if(msg == "hold" && lock == 0){llMessageLinked(LINK_THIS, 0, "Lock_By_GM", "ctrl");
                llSay(0, owname + ": Your Meter has been  Disabled by GM! (" + gmname + ")");}
                else if(msg == "kill" && dead == 0 && lock == 0){llMessageLinked(LINK_THIS, 0, "Killed_By_GM", "ctrl");
                llSay(0, owname + ": You have been GM killed! by (" + gmname + ")");}
                else if(msg == "deta"){llMessageLinked(LINK_THIS, 0, "Detach_By_GM", "ctrl");
                llSay(0, owname + ": Your Meter has been Detached by GM! (" + gmname + ")");}
                else if(msg == "ban"){llOwnerSay("Banned by "  + gmname);}
                else if(msg == "pban"){llOwnerSay("Permanent banned by " + gmname);}
                    }
                }
                if(client == agent)
                {
                if(msg == "allreset" && lock == 0){llMessageLinked(LINK_THIS, 0, "Reset_By_GM", "ctrl");
                llOwnerSay("Reset by GM request! (" + gmname + ")");ini();}
                if(msg == "gmcall" && status == 6){llOwnerSay("ATTENTION !! GM CALL FROM: " + gmname);}
                }
            }
        }
        else if(chnl == ctrl_chn && id == owner)
        {
            string msg = llToLower(mesg);
            if(msg == "reset"){llSay(0, "Reset by owner");llOwnerSay("Restarting...");ini();}
            else if(msg == "fullreset"){llSay(0, "Full reset by owner");llOwnerSay("Full restart...");llResetScript();}
            else if(msg == "melereport"){mrep = 1;}
            else if(msg == "melestop"){mrep = 0;}
            else if(msg == "menu"){llMessageLinked(LINK_THIS, 0, "Menu", "Skills");}
            else if(msg == "offense"){llMessageLinked(LINK_THIS, 0, "Offense", "Skills");}
            else if(msg == "support"){llMessageLinked(LINK_THIS, 0, "Support", "Skills");}
            else if(msg == "healing"){llMessageLinked(LINK_THIS, 0, "Healing", "Skills");}
            else if(msg == "f3" || msg == "f4" || msg ==  "f5" || msg ==  "f6" || msg ==  "f7" || msg ==  "f8" || msg ==  "f9")
            {string funct = "HUD_Key"+","+llToUpper(msg);llMessageLinked(LINK_THIS, 1, funct, "Skills");}
            else if(msg == "show"){shwstats = 1;}
            else if(msg == "hide"){shwstats = 0;}
            else if(msg == "color0"){colors = 0;text_color();save_color();} // White
            else if(msg == "color1"){colors = 1;text_color();save_color();} // Red
            else if(msg == "color2"){colors = 2;text_color();save_color();} // Green
            else if(msg == "color3"){colors = 3;text_color();save_color();} // Lime
            else if(msg == "color4"){colors = 4;text_color();save_color();} // Magenta
            else if(msg == "color5"){colors = 5;text_color();save_color();} // Blue
            else if(msg == "color6"){colors = 6;text_color();save_color();} // Yellow
            else if(msg == "color7"){colors = 7;text_color();save_color();} // Purpple
            else if(llGetSubString(msg, 0, 5) == "title "){
            Custom = llGetSubString(mesg, 6, -1);
            if(llToLower(Custom) == "none"){Custom = "";}
            if(llStringLength(Custom) > 30)
            {Custom = llGetSubString(Custom, 0, 30);llOwnerSay("Title is limited to 30 char. max.");}
            llMessageLinked(LINK_THIS, 0, Custom, "C_Text");
            txdata = "Save_Title" + "," + Custom;
            llMessageLinked(LINK_THIS, 0, txdata, "Snd_To_Bridge");
            }
        }
        if(chnl == chan && id == owner)
        {
            llListenRemove(lishnd);menup = 0;mentime = 0;llSetTimerEvent(0.0);
            string msg = llToLower(mesg);
            if(msg == "cancel"){msg = "";mesg = "";menlvl = 0;scn = 0;}
            if(menlvl == 0)
            {scn = 0;action = 0;
            if(msg == "hide"){llMessageLinked(LINK_THIS, 0, "Hide_GM", "ctrl");}
            else if(msg == "show"){llMessageLinked(LINK_THIS, 0, "Show_GM", "ctrl");}
            else if(msg == "lock"){action = 1;}
            else if(msg == "unlock"){action = 2;}
            else if(msg == "detach"){action = 3;}
            else if(msg == "reset"){action = 4;}
            else if(msg == "allreset"){gmallreset();}
            else if(msg == "kill"){action = 5;}
            else if(msg == "revive"){action = 6;}
            else if(msg == "set nocomb"){action = 7;}
            if(action != 0){scan();}
            }
            else if(menlvl == 1 && scn == 1)
            {stargetn = mesg;;stargetk = "";scn = 0;
            if (action == 1){txdata = "hold" + ",";}
            else if (action == 2){txdata = "unhold" + ",";}
            else if (action == 3){txdata = "deta" + ",";}
            else if (action == 4){txdata = "reset" + ",";}
            else if (action == 5){txdata = "kill" + ",";}
            else if (action == 6){txdata = "live" + ",";}
            else if (action == 7){txdata = "off" + ",";}
            findkey();action = 0;stargetn = "";txdata = "";
            }
        }
    }
    link_message(integer sender, integer num, string lmsg, key id)
    {
        if(id == "Display")
        {
            if(lmsg == "Txt_Color"){text_color();}
        }
        if(id == "Control")
        {
            if(lmsg == "GM_Menu"){menlvl = 0;openlisten();}
            if(lmsg == "XP_Info"){xpinfo();}
            if(lmsg == "initiate"){lvlup = 0;}
            else if(lmsg == "ticks" && nocomb == 0 && lvlup == 0){xpticks = num;experience += xpticks;
            llMessageLinked(LINK_THIS, experience, "Act_XP", "Mdsp");
            if(experience >= maxxp){experience = maxxp;levelup();}}// else{llOwnerSay("Got XP! >>> XP Tic: " + (string)xpticks);}}
            else if(lmsg == "Hide_GM"){gmlist = llListReplaceList((gmlist = []) + gmlist, ["Show"], 4, 4);}
            else if(lmsg == "Show_GM"){gmlist = llListReplaceList((gmlist = []) + gmlist, ["Hide"], 4, 4);}
            else if(lmsg == "Lock_ACK"){lock = 1;}
            else if(lmsg == "Unlock_ACK"){lock = 0;}
        }
        else if(id == "Intelli")
        {
            list tlist = llCSV2List(lmsg);
            intelli = (integer)llList2String(tlist, 0);
            intellr = (float)llList2String(tlist, 1);
            stam = (integer)llList2String(tlist, 2);
            dead = (integer)llList2String(tlist, 3);
            nocomb = (integer)llList2String(tlist, 4);
            racial = (integer)llList2String(tlist, 5);
            status = (integer)llList2String(tlist, 6);
            lock = (integer)llList2String(tlist, 7);
            experience = (integer)llList2String(tlist, 8);
            xpticks = (integer)llList2String(tlist, 9);
            level = (integer)llList2String(tlist, 10);
            sex = (integer)llList2String(tlist, 13);
            maxxp = (integer)llList2String(tlist, 14);//maxxp = (experience + 8); // xp for next level up
            if(status == 1){lock = 1;}else{lock = 0;}
        }
        else if(id == "Stamina")
        {
            list tlist = llCSV2List(lmsg);
            stam = (integer)llList2String(tlist, 0);
            dead = (integer)llList2String(tlist, 1);
            nocomb = (integer)llList2String(tlist, 2);
            racial = (integer)llList2String(tlist, 3);
            status = (integer)llList2String(tlist, 4);
            lock = (integer)llList2String(tlist, 5);
        }
        else if(id == "Grunt")
        {
            if(num == 1){brsk = 1;}
            else if(num == 0){brsk = 0;}
            if(dead == 0){grunt();}
            else if(dead == 1){if(sex == 1){llPlaySound("f743cad2-6c1d-eb22-9c5e-4f47053e9d63", 1.0);}
            else{llPlaySound("82038c9d-2288-de97-e619-6a1584cdbcc5", 1.0);}}
        }
        else if(id == "RESPONSE_SECURITY_LEVEL_UP")
        {
            if(num == 0){secure = lmsg;}
            lvlup_secure();
        }
        else if(id == "Serv_ID")
        {
            serv_id = lmsg;
            serv_owner = llGetOwnerKey(serv_id);
        }
        else if(id == "URL_Prefix")
        {
            prefixurl = lmsg;
        }
        else if (id == "relay_id") { relay_id = lmsg;}
        else if (id == "controls")
        {
            if(lmsg == "dead"){dead = 1;}
            if(lmsg == "live"){dead = 0;}
        }
    }
    sensor(integer num)
    {
        targets = [];tarnames = [];
        integer i;if(num > 11){num = 11;}
        for(i=0;i<num;i++){targets += [llDetectedKey(i)];tarnames += [llGetSubString(llDetectedName(i),0 ,15)];}
        scn = 1;menlvl = 1;openlisten();
    }
    no_sensor()
    {llOwnerSay("No One In Range !");
            targets = [];
            tarnames = [];
            scn = 0;
    }
    timer()
    {
        if(menup == 1){llListenRemove(lishnd);
        menlvl = 0;menup = 0;}
        llSetTimerEvent(0.0);
    }
    changed(integer mask)
    {
        if(mask & CHANGED_OWNER){llResetScript();}
    }
}