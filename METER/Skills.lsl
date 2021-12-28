key owner;
key serv_id;
key serv_owner;
integer scn;
integer mov2;
integer menup;
integer lishnd;
integer chan;
integer serlsn;
integer stat_rxchn = -627782887; // Dealer API channel. (Not in use now)
integer serv_rxchn = -1999999429;
integer mstr_rxchn = -1999995906; // combat channel.
integer nhud_rxchn = -1999994906; // huds channel.
integer spectrum;
integer repout;
integer offehot;
integer healhot;
integer supphot;
integer scandis;
integer intelli; // stats
float intellr; // race
float intellf; // factor
integer lock;
integer status;
integer dead;
integer nocomb;
integer stam;
integer life;
integer racial;
integer sex;
string skname;
integer sklevel;
integer method;
integer reach;
integer skracial;
integer stamself;
integer stamother;
integer healself;
integer healother;
integer skeffect;
integer ammount;
integer lasting;
integer cooldown;
integer hotsw;
integer savsw;
integer savbt;
integer silenced;
string owname;
string mctr_psw = "01!hWelcr*dNCSv1.05906";
string work_psw = "QWERTY!";
string serv_msg;
string txdata;
string stat_data;
string set;
string race;
string class;
string funsav;
string hotkey;
string hotf3;
string hotf4;
string hotf5;
string hotf6;
string hotf7;
string hotf8;
string hotf9;
string qbutt;
string qbtn1;
string qbtn2;
string qbtn3;
string skill;
string skclass;
string sktosend;
string secure;
key agent_1;
key agent_2;
key agent_3;
key targetk;
key stargetk;
string targetn;
string stargetn;
key agentk;
string agentn;
string prefixurl = "https://ncs-sl-dev.herokuapp.com"; //"https://www.ncs-sl.com";
string url;
string relay_id;
integer menlvl;
integer mentime = 60;
list lskout;
list targets;
list tarnames;
list skills;
list offense;
list support;
list healing;
list sourcelst;
list destinlst;
list menulist = ["CANCEL", "Show stats", "GM Call", "Offense", "Healing", "Support", "Profile", "Off", "More"];
list setflist = ["CANCEL", "Clear", " ", "Offense", "Healing", "Support"];
list offelist = ["CANCEL"];
list supplist = ["CANCEL"];
list heallist = ["CANCEL"];
list morelist = ["CANCEL", "XP info", "Players", "Set Button", "1st P on", "NCS Help"];
list setblist = ["button 1", "button 2", "button 3"];

load_profile()
{
    if (relay_id == "") return;

    llMessageLinked(LINK_THIS, 0, "Sec_rq2", "Sec_rq2");
    string url =  prefixurl + "/relay/api/" + (string) relay_id + "/security/" + (string)owner;
    //llSay(0, url);
    llHTTPRequest(url, [HTTP_METHOD, "PUT"], (string)owner);
}
clear_custom_settings()
{
    hotf3 = "";hotf4 = "";hotf5 = "";hotf6 = "";hotf7 = "";hotf8 = "";hotf9 = "";
    qbtn1 = "";qbtn2 = "";qbtn3 = "";setblist = ["button 1", "button 2", "button 3"];
    offense = [];support = [];healing = [];
    offelist = ["CANCEL"];supplist = ["CANCEL"];heallist = ["CANCEL"];
    llOwnerSay("Status report:\nNew Race / Class detected...
    \nSet your function keys in your NCS Hud...
    Use (Set, [F3 ~ F9], Skill class, Skill) to set special function keys...
    \nAnd your custom buttons in:(Menu, More, Set buttons).");
}
gmcalled()
{
    llSay(0,owname + " has called the GM for assistence.");
    serv_msg = (mctr_psw + "," + (string)owner + "," + "gmcall" + "," + (string)owner);
    llRegionSay(serv_rxchn,serv_msg);
}
poff()
{
    llMessageLinked(LINK_THIS, 0, "Pow_off", "ctrl");nocomb = 1;
    menulist = llListReplaceList((menulist = []) + menulist, ["On"], 7, 7);
}
poon()
{
    llMessageLinked(LINK_THIS, 0, "Pow_on", "ctrl");nocomb = 0;
    menulist = llListReplaceList((menulist = []) + menulist, ["Off"], 7, 7);
}
set_fun()
{
             if(set == "F3"){hotkey = hotf3;}
        else if(set == "F4"){hotkey = hotf4;}
        else if(set == "F5"){hotkey = hotf5;}
        else if(set == "F6"){hotkey = hotf6;}
        else if(set == "F7"){hotkey = hotf7;}
        else if(set == "F8"){hotkey = hotf8;}
        else if(set == "F9"){hotkey = hotf9;}
        if(hotkey == ""){hotkey = "Empty!";}
        else{list fkey = llCSV2List(hotkey);
        string fskill = llList2String(fkey, 1);
        hotkey = fskill;}
        savsw = 1;menlvl = 4;openlisten();
}
sav_fun()
{
             if(set == "F3"){hotf3 = funsav;}
        else if(set == "F4"){hotf4 = funsav;}
        else if(set == "F5"){hotf5 = funsav;}
        else if(set == "F6"){hotf6 = funsav;}
        else if(set == "F7"){hotf7 = funsav;}
        else if(set == "F8"){hotf8 = funsav;}
        else if(set == "F9"){hotf9 = funsav;}
        if(funsav != ""){list fkey = llCSV2List(funsav);
        string fskill = llList2String(fkey, 1);
        llOwnerSay(set + " is now set for " + fskill);}
        else{llOwnerSay(set + " memory has been cleared.");
        if(savbt == 1){qbtn1 = "";setblist = llListReplaceList((setblist = []) + setblist, ["button 1"], 0, 0);}
        else if(savbt == 2){qbtn2 = "";setblist = llListReplaceList((setblist = []) + setblist, ["button 2"], 1, 1);}
        else if(savbt == 3){qbtn3 = "";setblist = llListReplaceList((setblist = []) + setblist, ["button 3"], 2, 2);}}
}
sav_butt()
{
        savbt = 0;if(funsav != ""){list fkey = llCSV2List(funsav);
        string fskill = llList2String(fkey, 1);
        if(set == "button 1"){qbtn1 = llList2String(fkey, 0);
        setblist = llListReplaceList((setblist = []) + setblist, [fskill], 0, 0);}
        else if(set == "button 2"){qbtn2 = llList2String(fkey, 0);
        setblist = llListReplaceList((setblist = []) + setblist, [fskill], 1, 1);}
        else if(set == "button 3"){qbtn3 = llList2String(fkey, 0);
        setblist = llListReplaceList((setblist = []) + setblist, [fskill], 2, 2);}
        llOwnerSay(set + " is now set for " + fskill);}
}
scan()
{
        if(scandis == 0) {
            scandis = 40;
        }

        llSensor("", "", AGENT, scandis, PI);

        scandis = 0;
}
send_funskill()
{
        if(set == "F3"){hotkey = hotf3;}
        else if(set == "F4"){hotkey = hotf4;}
        else if(set == "F5"){hotkey = hotf5;}
        else if(set == "F6"){hotkey = hotf6;}
        else if(set == "F7"){hotkey = hotf7;}
        else if(set == "F8"){hotkey = hotf8;}
        else if(set == "F9"){hotkey = hotf9;}
        if(hotkey == ""){llOwnerSay("Hot Key " + set + " is not assigned yet.");
        llPlaySound("0ef4f264-a224-23d6-8f52-3b1941aa1fe1",1.0);}
        else{list skout = llCSV2List(hotkey);
        skclass = llList2String(skout,0);
        sktosend = llList2String(skout,1);send_skill();}
}
send_skill()
{
    if (silenced > 0) {
        llOwnerSay("You are silenced. Can't use skills");
        return;
    }
        if(nocomb == 0 && lock == 0)
        {
            lskout = [];stargetk = "";hotsw = 0;
            if(skclass == "Offense")
            {
                lskout = offense;
                if(offehot != 0)
                {
                    skillhot();
                }
            }
            else if(skclass == "Support")
            {
                lskout = support;
                if(supphot != 0)
                {
                    skillhot();
                }
            }
        else if(skclass == "Healing")
        {
            lskout = healing;
            if(healhot != 0)
            {
                skillhot();
            }
        }
        if(hotsw == 0)
        {
            loadskill();
            if(dead == 0 || skeffect == 13)
             {
                integer listlen = llGetListLength(lskout);
                if(listlen != 13)
                {
                    if(stamself != 0 && (stam + stamself) < 0)
                    {
                        notenughstam();
                    }
                    else if(skracial != 0 && (racial + skracial) < 0)
                    {
                        noracial();
                    }
                }
                if(method == 3 && hotsw == 0)
                {
                    stargetk = owner;tx_skill();
                }
                else if(method != 0)
                {
                    gettarget();
                }
            }
            else
            {
                llOwnerSay("Skill failed to load ! Please restart your meter.");
            }
        }
    }
}
noracial()
{
        llOwnerSay("You don't have enough racial points to use " + skname);hotsw = 1;
}
skillhot()
{
        llOwnerSay("You can't use " + llToLower(skclass) + " skills yet!");hotsw = 1;
}
notenughstam()
{
        llOwnerSay("You don't have enough stamina to use " + skname);hotsw = 1;
}
loadskill()
{
        integer listlen = llGetListLength(lskout);integer i;for(i = 0; i < listlen; i += 14)
        {if(sktosend == llList2String(lskout, i)){lskout = llList2List(lskout, i, (i + 13));i = listlen;}}
        skname = llList2String(lskout, 0);sklevel = (integer)llList2String(lskout, 1);
        method = (integer)llList2String(lskout, 2);reach = (integer)llList2String(lskout, 3);
        skracial = (integer)llList2String(lskout, 4);stamself = (integer)llList2String(lskout, 5);
        stamother = (integer)llList2String(lskout, 6);healself = (integer)llList2String(lskout, 7);
        healother = (integer)llList2String(lskout, 8);skeffect = (integer)llList2String(lskout, 9);
        ammount = (integer)llList2String(lskout, 10);lasting = (integer)llList2String(lskout, 11);
        cooldown = (integer)llList2String(lskout, 12);intellf = (float)llList2String(lskout, 13);
}
gettarget()
{
        scn = 0;
        if(targetk != "" && method != 4 && skclass == "Offense"){stargetk = targetk;stargetn = targetn;scn = 1;}
        else if(agentk != "" && method != 4 && skclass != "Offense"){stargetk = agentk;stargetn = agentn;scn = 1;}
        scandis = reach;if(hotsw == 0){scan();}
}
findkey()
{
        integer listlen = llGetListLength(tarnames);integer i;for(i = 0; i < listlen; i ++)
        {if(stargetn == llList2String(tarnames, i)){stargetk = llList2Key(targets, i);i = listlen;}}
}
tx_skill()
{
    if (stargetk != "") {
      txdata = "";
      string trailingtext = " on itself";
      if (sex == 0) {
        trailingtext = " on herself";
      }
      if (dead == 0 && skeffect == 13 && method == 3) {
        llOwnerSay("Can't be resurrected if you are not dead yet!");
        cooldown = 0;
        method = 0;
        skclass = "";
      } // you are alive! can't Resurrect!
      if (skclass == "Offense") {
        llMessageLinked(LINK_THIS, cooldown, "offe", "cooldown");
        offehot = 1;
      } else if (skclass == "Support") {
        llMessageLinked(LINK_THIS, cooldown, "supp", "cooldown");
        supphot = 1;
      } else if (skclass == "Healing") {
        llMessageLinked(LINK_THIS, cooldown, "heal", "cooldown");
        healhot = 1;
      }
      float fvalue = llFrand(299) + 1;
      integer ivalue = llRound(fvalue);
      float fvalue2 = llFrand(299) + 1;
      integer ivalue2 = llRound(fvalue2);
      if (ivalue == ivalue2 && method != 3) {
        llSay(0, owname + " failed to use " + skname);
      }
      //-----------------------------------------------------------------------------------------
      else {
        float dmg = ((intelli * intellr) * 0.0015 + intellf); //llOwnerSay("Skill Raw: " + llList2CSV(lskout));
        if (stamself > 0) {
          float selfstam = dmg * stamself;
          stamself = llRound(selfstam);
          lskout = llListReplaceList((lskout = []) + lskout, [stamself], 5, 5);
        }
        if (healself > 0) {
          healself = llRound(dmg * healself);
          lskout = llListReplaceList((lskout = []) + lskout, [healself], 7, 7);
        }
        if (skeffect == 4 || skeffect == 8 || skeffect == 3) {
          float selfammo = dmg * ammount;
          ammount = llRound(selfammo);
          lskout = llListReplaceList((lskout = []) + lskout, [ammount], 10, 10);
        }
        float stamdmg = dmg * stamother;
        stamother = llRound(stamdmg);
        float lifedmg = dmg * healother;
        healother = llRound(lifedmg);
        lskout = llListReplaceList((lskout = []) + lskout, [stamother], 6, 6);
        lskout = llListReplaceList((lskout = []) + lskout, [healother], 8, 8);
        //-----------------------------------------------------------------------------------------
        if (skeffect == 2) {
          llMessageLinked(LINK_THIS, 0, "course", "controls");
          llSleep(0.5);
        }
        //-----------------------------------------------------------------------------------------
        else if (dead == 1 && skeffect == 13 && method == 3) {
          dead = 0;
          llPlaySound("f8a2f1d6-c5b0-ff5b-d6f8-5c1a447cb6d6", 1.0); // Resurrect!
          llMessageLinked(LINK_THIS, 0, "rEvI", "stats");
          llMessageLinked(LINK_THIS, 0, "Zomb_live", "controls");
          llSleep(1.0);
        }
        //-----------------------------------------------------------------------------------------
        if (method == 3) {
          string skillself = "Skill_Self" + "," + llList2CSV(lskout); //llOwnerSay(llList2CSV(lskout));
          llMessageLinked(LINK_THIS, 0, skillself, "SkIlLs");
          llSay(0, owname + " applies " + skname + trailingtext);
        }
        //llSay(0, "Sent skill: " + skillself);}
        else if (method == 4) {
          txdata = work_psw + "," + (string) owner + "," + "ASkill" + "," +
            (string) intelli + "," + (string) owner + "," + skclass + "," + (string) method + "," + llList2CSV(lskout);

          payskill();
          llSay(0, owname + " drops " + skname + " on the zone");
        } else {
          if (skeffect == 1 || skeffect == 27 && method == 2) {
            mov2 = 1;
            llSensor("", stargetk, AGENT, 20.0, PI);
          } else if (llGetSubString(skname, 0, 2) == "KOB") {
            llMessageLinked(LINK_THIS, 0, "kos", "ctrl");
          }
          if (method != 0) {
            txdata = work_psw + "," + (string) owner + "," + "RSkill" + "," + (string) intelli + "," +
              (string) stargetk + "," + skclass + "," + (string) method + "," + llList2CSV(lskout);

            payskill();
            llSay(0, owname + " blow " + skname + " to " + llKey2Name(stargetk));
          }
        }
      }
    }
}
payskill()
{
        integer mchn = mstr_rxchn + spectrum;
        string skillself = "Skill_Pay" + "," + llList2CSV(lskout);
        llMessageLinked(LINK_THIS, 0, skillself, "SkIlLs");
        if(reach <= 10){llWhisper(mchn, txdata);}
        else if(reach <= 20){llSay(mchn, txdata);} // SALIDA SKILL !
        else{llShout(mchn, txdata);}
}
skillsmen()
{
        integer oflen = llGetListLength(sourcelst);
        integer sparam = 14;
        integer skl;
        integer i;
        for(i = 0;i < oflen; i += sparam)
        {
            destinlst += llList2String(sourcelst, skl);
            skl += sparam;
        }
        sourcelst = [];
}
openlisten()
{
    if(lock == 0){
    if(menup == 1){llListenRemove(lishnd);}
    float FloatValue  = 48637 + llFrand(- 5814963);
    chan = llRound(FloatValue);
    lishnd = llListen(chan, "", owner, "");
    string stskill = "";
    if(savsw != 0){stskill = "\nChoose a skill for " + set;}
    menup = 1;
    if(savbt != 0){stskill = "\nChoose a skill for " + set;}
    if(menlvl == 0){llDialog(owner, "NCS Menu:", menulist + setblist, chan);}
    else if(menlvl == 1){llDialog(owner, "NCS Offensive Skills:" + stskill, offelist , chan);}
    else if(menlvl == 2){llDialog(owner, "NCS Support Skills:" + stskill, supplist , chan);}
    else if(menlvl == 3){llDialog(owner, "NCS Healing Skills:" + stskill, heallist , chan);}
    else if(menlvl == 4){llDialog(owner, "NCS Hot keys assign.\n" + set + " is set to: "
    + hotkey +"\nChoose a new skill class for: " + set, setflist , chan);}
    else if(menlvl == 5){llDialog(owner,"NCS Target Selection:\n" + "You can choose a target", ["CANCEL"] + tarnames,chan);}
    else if(menlvl == 6){llDialog(owner, "NCS Menu:", morelist , chan);}
    else if(menlvl == 7){llDialog(owner, "NCS Quick Button Set:\nChoose a quick button to set: ", setblist + ["CANCEL"], chan);}
    else if(menlvl == 8){llDialog(owner, "NCS Quick Button assign.\n" + set + " is set to: "
    + qbutt +"\nChoose a new skill class for: " + set, setflist , chan);}
    llSetTimerEvent(mentime);}
}
ini()
{
    owner = llGetOwner();menup = 0;
    owname = llKey2Name(llGetOwner());
    set = "";scn = 0;hotsw = 0;offehot = 0;
    supphot = 0;healhot = 0;targetk = "";
    stargetk = "";targetn = "";stargetn = "";
    agentk = "";agentn = "";agent_1 = "";agent_2 = "";agent_3 = "";
    offelist = ["CANCEL"];
    supplist = ["CANCEL"];
    heallist = ["CANCEL"];
   // url = "https://immense-river-36848.herokuapp.com/view/profile/levelup/index.html?uuid=" + (string)owner + "&t=";
}
default
{
    state_entry()
    {
        ini();
    }
    link_message(integer sender, integer num, string lmsg, key id)
    {
         if(id == "BootSec")
        {
            spectrum = num;//llOwnerSay("From Skills: Got Boot Spectrum = " + (string)spectrum);
        }
        else if (id == "ctrl")
        {
            if(lmsg == "Shrd_Spc")
            {
            spectrum = num;//llOwnerSay("From Skills: Got Shared Spectrum = " + (string)spectrum);
            }
        }
        if(num == 0){
        if(id == "cools")
        {
            string hudmsg = lmsg + "_H";
            llWhisper(nhud_rxchn, work_psw + "," + (string)owner + "," + hudmsg);
            if(lmsg == "offe"){offehot = 0;}
            else if(lmsg == "supp"){supphot = 0;}
            else if(lmsg == "heal"){healhot = 0;}
            else if(lmsg == "All"){offehot = 0;supphot = 0;healhot = 0;}
        }
        else if(id == "RESPONSE_SECURITY_PROFILE")
        {
            if(num == 0){secure = lmsg;}
            string url;
            if(menup == 2)
            {
                url = prefixurl + "/view/profile/levelup/index.html?uuid=" + (string)owner + "&t=" + secure;
                llLoadURL(owner, "You have Leveled Up!\nGo to NCS website?", url);
            }
            else
            {
                url = prefixurl + "/view/profile/index.html?uuid=" + (string)owner + "&t=" + secure;
            //  llSay(0, url);
                llLoadURL(owner, "View your NCS profile on the web?", url);
            }
        }
        else if(id == "URL_Prefix")
        {
           prefixurl = lmsg;
        }
        else if(id == "Intelli")
        {
            list tlist = llCSV2List(lmsg);
            intelli = (integer)llList2String(tlist, 0);
            intellr = (float)llList2String(tlist, 1);
            stam = (integer)llList2String(tlist, 2);
            dead = (integer)llList2String(tlist, 3);
            nocomb = (integer)llList2String(tlist, 4);if(nocomb == 0){poon();}
            racial = (integer)llList2String(tlist, 5);
            status = (integer)llList2String(tlist, 6);
            lock = (integer)llList2String(tlist, 7);
            sex = (integer)llList2String(tlist, 13);
            //xperience = (integer)llList2String(tlist, 8);
           // xptics = (integer)llList2String(tlist, 9);
            //level = (integer)llList2String(tlist, 10);
            //string loadrace = (string)llList2String(tlist, 11);
           // string loadclass = (string)llList2String(tlist, 12);
           // if(loadrace != race || loadclass != class){race = loadrace;class = loadclass;clear_custom_settings();}
            if(status == 1){lock = 1;}else{lock = 0;}
            if(status == 6){menulist = llListReplaceList((menulist = []) + menulist, ["GM Menu"], 2, 2);}
            else{menulist = llListReplaceList((menulist = []) + menulist, ["GM Call"], 2, 2);}
        }
      //  else if(id == "Info")
     //   {
         //   if(lmsg == "Poll_Rep"){repout = 1;} // This was to update data to enhanced weapons.
      //  }
        else if(id == "RInfo") // Race has changed!
        {
            if(lmsg != race){race = lmsg;clear_custom_settings();}
        }
        else if(id == "CInfo") // Class has changed!
        {
            if(lmsg != class){class = lmsg;clear_custom_settings();}
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
          //  if(repout == 1){repout = 0;
          //  stat_data = (string)owner + "," + work_psw + "," + llList2CSV(tlist); \\ commented code (was for the dealer API)
          //  llWhisper(stat_rxchn, stat_data);}//llSay(0, stat_data);
        }
        else if(id == "ctrl")
        {
            if(lmsg == "Off_By_GM"){poff();}
             else if(lmsg == "OFF"){menup = 2;}
        }
        else if(id == "Control")
        {
            if(lmsg == "Lock_ACK"){lock = 1;}
            else if(lmsg == "Unlock_ACK"){lock = 0;}
        }
        else if(id == "Main_Boot")
        {
            ini();
        }
        else if(lmsg == "Hud_Trgts" && id == "Sync_Hud")
        {
            string hudtxx = work_psw + "," + (string)owner + "," + "Hud_Targets" + ","
            + agentn + "," + targetn + "," + (string)agent_1 + "," + (string)agent_2
            + "," + (string)agent_3;
            llWhisper(nhud_rxchn,hudtxx);
        }
        else if(id != "Skills")
        {
             if(id == "Serv_ID")
            {
                serv_id = lmsg;
                serv_owner = llGetOwnerKey(serv_id);
            }
             else if(id == "Offensive_0")
            {
                offense = llCSV2List(lmsg);
                sourcelst = offense;
                skillsmen();
                offelist = ["CANCEL"] + destinlst;
                destinlst = [];
                llMessageLinked(LINK_THIS, 3, "SkIlLzOk!", "NCS_BOOT");
            }
             else if(id == "Support")
            {
                support = llCSV2List(lmsg);
                sourcelst = support;
                skillsmen();
                supplist = ["CANCEL"] + destinlst;
                destinlst = [];
                llMessageLinked(LINK_THIS, 4, "SkIlLzOk!", "NCS_BOOT");
            }
            else if(id == "Healing")
            {
                healing = llCSV2List(lmsg);
                sourcelst = healing;
                skillsmen();
                heallist = ["CANCEL"] + destinlst;
                destinlst = [];
                llMessageLinked(LINK_THIS, 5, "SkIlLzOk!", "NCS_BOOT");
            }}
        }
             if(id == "Skills"){
                if(num == 0){if(lmsg == "Menu"){menlvl = 0;openlisten();}
                if(lmsg == "Offense"){menlvl = 1;openlisten();}
                if(lmsg == "Support"){menlvl = 2;openlisten();}
                if(lmsg == "Healing"){menlvl = 3;openlisten();}}

                if (lmsg == "silenced") {
                    silenced = num;
                }
                else if(num == 1)
                {
                    list data = llCSV2List(lmsg);
                    string fun = (string)llList2String(data,0);
                    set = (string)llList2String(data,1);
                    if(fun == "Set_Key"){set_fun();}
                    else if(fun == "HUD_Key"){if(set == "F2")
                    {menlvl = 0;openlisten();}
                    else if(set != "Pow"){send_funskill();}
                    else if(set == "Pow" && nocomb == 0){poff();}
                    else if(set == "Pow" && nocomb == 1){poon();}}
                    else if(fun == "Hud_Def"){agentn = set;
                    agentk = (key)llList2String(data,2);}
                    else if(fun == "Hud_Offe"){targetn = set;
                    targetk = (key)llList2String(data,2);}
                    else if(fun =="Hud_Min1"){agent_1 = (key)llList2String(data,2);}
                }
            }
            else if (id == "relay_id") { relay_id = lmsg;}
    }
    listen(integer chnl, string name, key id, string mesg)
    {
        if(chnl == chan && id == owner)
        {
            llListenRemove(lishnd);menup = 0;mentime = 0;llSetTimerEvent(0.0);
            string msg = llToLower(mesg);integer skps;
            if(msg == "clear"){msg = "";mesg = "";savsw = 0;menlvl = 0;funsav = "";scn = 0;sav_fun();
            savbt = 0;qbutt = "";set = "";scn = 0;}
            if(msg == "cancel"){msg = "";mesg = "";menlvl = 0;savsw = 0;savbt = 0;funsav = "";
            qbutt = "";set = "";scn = 0;}
            if(msg == "offense" || msg == "support" || msg == "healing")
            {if(savsw == 1){funsav = mesg;savsw = 2;skps = 1;}
            else if(savbt != 0){funsav = mesg;savsw = 3;skps = 1;}}
            if(skps == 0 && savsw == 2){funsav += "," + mesg;savsw = 0;sav_fun();
            msg = "";mesg = "";menlvl = 0;savsw = 0;funsav = "";set = "";scn = 0;}
            else if(skps == 0 && savbt != 0 && savsw == 3){funsav += "," + mesg;sav_butt();
            msg = "";mesg = "";menlvl = 0;savsw = 0;funsav = "";set = "";scn = 0;}
            if(menlvl == 0){if(msg == "offense"){menlvl = 1;openlisten();}
                else if(msg == "support"){menlvl = 2;openlisten();}
                else if(msg == "healing"){menlvl = 3;openlisten();}
                else if(msg == "show stats"){llMessageLinked(LINK_THIS, 0, "show", "ctrl");
                menulist = llListReplaceList((menulist = []) + menulist, ["Hide stats"], 1, 1);}
                else if(msg == "hide stats"){llMessageLinked(LINK_THIS, 0, "hide", "ctrl");
                menulist = llListReplaceList((menulist = []) + menulist, ["Show stats"], 1, 1);}
                else if(msg == "gm call"){gmcalled();}
                else if(msg == "gm menu" && status == 6){llMessageLinked(LINK_THIS, 0, "GM_Menu", "Control");}
                else if(msg == "more"){menlvl = 6;openlisten();}
                else if(msg == "off"){llMessageLinked(LINK_THIS, 0, "Pow_off", "ctrl");nocomb = 1;
                menulist = llListReplaceList((menulist = []) + menulist, ["On"], 7, 7);}
                else if(msg == "on"){llMessageLinked(LINK_THIS, 0, "Pow_on", "ctrl");nocomb = 0;
                menulist = llListReplaceList((menulist = []) + menulist, ["Off"], 7, 7);}
                else if(msg == "profile"){load_profile();}
                else if(mesg ==  "button 1" || mesg ==  "button 2" || mesg ==  "button 3")
                {llOwnerSay(mesg + " has not been set yet!");}
                else if(mesg == llList2String(setblist, 0)){skclass = qbtn1;sktosend = mesg;send_skill();}
                else if(mesg == llList2String(setblist, 1)){skclass = qbtn2;sktosend = mesg;send_skill();}
                else if(mesg == llList2String(setblist, 2)){skclass = qbtn3;sktosend = mesg;send_skill();}}
            else if(menlvl == 1 && savsw == 0 && savbt == 0){skclass = "Offense";sktosend = mesg;send_skill();}
            else if(menlvl == 2 && savsw == 0 && savbt == 0){skclass = "Support";sktosend = mesg;send_skill();}
            else if(menlvl == 3 && savsw == 0 && savbt == 0){skclass = "Healing";sktosend = mesg;send_skill();}
            else if(menlvl == 4 || menlvl == 8){if(msg == "offense"){menlvl = 1;}
            else if(msg == "support"){menlvl = 2;}
            else if(msg == "healing"){menlvl = 3;}openlisten();}
            else if(menlvl == 5){stargetn = mesg;findkey();tx_skill();}
            else if(menlvl == 6){if(msg == "xp info"){llMessageLinked(LINK_THIS, 0, "XP_Info", "Control");}
            else if(msg == "set button"){menlvl = 7;openlisten();}}
            else if(menlvl == 7){if(mesg == llList2String(setblist, 0)){savbt = 1;set = "button 1";}
            else if(mesg == llList2String(setblist, 1)){savbt = 2;set = "button 2";}
            else if(mesg == llList2String(setblist, 2)){savbt = 3;set = "button 3";}
            if(savbt != 0 && llGetSubString(msg, 0 , 5) == "button"){qbutt = "Empty";}
            else if(savbt != 0){qbutt = mesg;}menlvl = 8;openlisten();}
        }
    }
    sensor(integer num)
    {
        //llOwnerSay("Metodo = " + (string)method);
        integer txd = 0;
        if(mov2 == 0){targets = [];tarnames = [];integer i;if(num > 11){num = 11;}
        for(i=0;i<num;i++){targets += [llDetectedKey(i)];tarnames += [llGetSubString(llDetectedName(i), 0 , 19)];}
        if(method == 4){scn = 0;stargetk = llList2CSV(targets);txd = 1;tx_skill();}
        else if(scn == 1){integer listlen = llGetListLength(tarnames);
        integer i;for(i = 0; i < listlen; i ++)
        {if(stargetn == llList2String(tarnames, i)){i = listlen;scn = 0;txd = 1;tx_skill();}}}
        if(method == 1 && txd == 0){stargetk = (key)llList2String(targets, 0);
        stargetn = llList2String(tarnames, 0);scn = 0;txd = 1;tx_skill();}
        else if(method == 2 && txd == 0){menlvl = 5;openlisten();}}
        else{mov2 = 0;vector pos = llDetectedPos(0);vector offset =<-1,0,1>;pos+=offset;
        llMoveToTarget(pos,0.4);llSleep(0.3);llStopMoveToTarget();}
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
        menlvl = 0;savsw = 0;savbt = 0;funsav = "";
        qbutt = "";set = "";scn = 0;menup = 0;}
        llSetTimerEvent(0.0);
    }
    changed(integer mask)
    {
        if(mask & CHANGED_OWNER){llResetScript();}
    }
}