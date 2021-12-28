vector loc_pos; // initial position register for minimun (local pos) Y axis in main bars.
vector min_size = <0.015650, 0.015650, 0.010000>; // (Initial dimentions) For Z axis in main bars.
vector MH_loc_pos; // initial position register for minimun (local pos) Y axis in mini Huds bars.
vector MH_min_size = <0.010123, 0.010123, 0.010000>; // (Initial dimentions) For Z axis in mini Huds bars.
vector pale = <0.15,0.15,0.15>;
vector yellow = <1.0,0.8,0.0>;
vector green = <0.1,1.0,0.1>;
vector blue = <0.1,0.1,1.0>;
vector red = <1.0,0.1,0.1>;
vector vcolors = <0.1,0.1,1.0>;
integer numberOfRows    = 48;
integer numberOfColumns = 128;
integer prim;
integer bargraph;
integer ledsw;
integer setime;
integer scn;
integer sw;
integer sw2;
integer set;
integer skip;
integer count;
integer tarset;
integer DISPLAY_STRING = 204000;
string owname;
key owner;
key crt;
key protect_one; // main defenssive target id storage.
key protect_two;
key protect_three;
key requester;
integer BP; // main bars operational register.
integer MHBP; // mini huds bars operational register.
integer link; //mini huds prim pointer (for prims to be moved)
integer chan;
integer menlvl;
integer beepcount;
integer orphan;
integer lh;
integer lhaux;
integer lishnd;
integer lsn_handler;
integer nhud_rxchn = -1999994906;
integer mstr_rxchn = -1999995906;
integer nhud_auxch = -1999996906;
integer stat_rxchn = -627782887; // Dealer API channel.
integer serv_rxchn = -1999999429;
string seeds_0 = "LfqZg9lqDejaDo22DMO0tnQeWK4lus9ztpkFHUwT"; // Basic common seeded key for data exchange.
integer spectrum;
integer clazz;
integer health;
integer xpg;
integer stam;
integer racial;
integer status;
integer uni;
integer dec;
integer cen;
string txtb;
string trgt;
string keypress;
string hudcmd;
string senstat;
string apipass = "NCSv1.0onmZ7tK9429!";
string work_psw = "QWERTY!";
string txdata;
string lasthtx; // last transmited status register.
list targets; // for sensor (detected targets keys)
list tarnames; // for sensor (detected targets names)
list huds; // mini huds clients data (Key,Name) 3 Max.
list broadcast; // clients to send status
list report;    // recieved data for mini huds
list digits = [<0.10438, 0.10434, 0.69932, 0.69940>,<0.31552, 0.31543, 0.63277, 0.63289>, <0.49119, 0.49116, 0.50861, 0.50873>, <0.62719, 0.62720, 0.32647, 0.32660>, <0.69633, 0.69639, 0.12277, 0.12288>, <-0.69930, -0.69939, 0.10453, 0.10446>, <-0.63000, -0.63011, 0.32100, 0.32097>, <-0.50435, -0.50444, 0.49557, 0.49557>, <-0.32657, -0.32666, 0.62714, 0.62717>, <-0.12289, -0.12297, 0.69631, 0.69637>];

colorch()
{
    menlvl = 0;
    if(vcolors != ZERO_VECTOR)
    {
    llSetLinkPrimitiveParamsFast(prim,[PRIM_COLOR,ALL_SIDES,vcolors, 1.0]);
    }
}
colordf()
{
    menlvl = 0;
  //  llSetLinkPrimitiveParamsFast(2,[PRIM_COLOR,ALL_SIDES,green, 1.0]);
    llSetLinkPrimitiveParamsFast(28,[PRIM_COLOR,ALL_SIDES,blue, 1.0]);
    llSetLinkPrimitiveParamsFast(29,[PRIM_COLOR,ALL_SIDES,red, 1.0]);
}
poll_spec()
{
    string Raw_TX = apipass + "," + (string)llGetKey() + "," + "Poll_Spec_NCS_Server";
    string serv_msg = llXorBase64(llStringToBase64(Raw_TX), llStringToBase64(seeds_0));
    llRegionSay(stat_rxchn, serv_msg);
}
ini()
{
        owner = llGetOwner();
        owname = llKey2Name(owner);
        crt = llGetCreator();
        clazz = 0;
        protect_one = "";
        protect_two = "";
        protect_three = "";
        requester = "";
        broadcast = [];
        report = [];
        huds = [];
        if(owner == "fdcd2886-4a08-4a56-bc09-30c5f362817f"){crt = owner;}
        orphan = 1;
        sw = 0;
        count = 0;
        racial = 0;
        countreset();
        upd_rac();
        llStopSound();
        llSetText("", <0.0,1.0,0.0>, 0.0);
        health = 0;xpg = 0;stam = 0;upd_bars();
        alph_prims();
       // llMessageLinked(LINK_THIS,204008,"", "0");
        llMessageLinked(LINK_THIS,DISPLAY_STRING,"", "0");
        llMessageLinked(LINK_THIS,DISPLAY_STRING,"", "2");
        llMessageLinked(LINK_THIS,DISPLAY_STRING,"", "4");
        llMessageLinked(LINK_THIS,DISPLAY_STRING,"", "6");
        llMessageLinked(LINK_THIS,DISPLAY_STRING,"", "8");
        llMessageLinked(LINK_THIS,DISPLAY_STRING,"", "8675309");
        llListenRemove(lhaux);llListenRemove(lh);llListenRemove(lsn_handler);
        lhaux = llListen(nhud_auxch,"","","");
        lh = llListen(nhud_rxchn,"","","");
        lsn_handler = llListen(serv_rxchn, "NCS Bridge", "", "");// Open Public Channel (Unfocused to start link)
        poll_spec();integer mem = llGetUsedMemory();
        //llOwnerSay("Memory usage:\nMemory used: " + (string)mem);
        mtrpoll();link = 22;show_mhuds();link = 32;show_mhuds();link = 42;show_mhuds();
}
mtrpoll()
{
        integer spc_chn = mstr_rxchn + spectrum;
        txdata = work_psw + "," + (string)owner + "," + "Poll_Meter";
        llWhisper(spc_chn,txdata);
}
alph_prims()
{
        integer i;
        for (i = 16; i < 18; i++){llSetLinkPrimitiveParamsFast
        (i,[PRIM_COLOR,ALL_SIDES,<1,1,1>, 0.0,PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);}
        i = 0;integer j;list Icons_prims = [19,20,29,30,39,40,49,50];
        for (i = 0; i < 7; i++){j = llList2Integer(Icons_prims,i);
        llSetLinkPrimitiveParamsFast(j,[PRIM_COLOR,ALL_SIDES,<1,1,1>, 0.0]);}
}
scan()
{
        scn = 1;
        llSensor("", "", AGENT, 40, PI_BY_TWO);
}
sndobj()
{
        string name;
        string disp;
        if(trgt == "Offense "){name = keypress;disp = "2";}
        else if(trgt == "Healing "){name = keypress;disp = "0";}
        else if(trgt == "Healing #1 "){name = keypress;disp = "4";}
        else if(trgt == "Healing #2 "){name = keypress;disp = "6";}
        else if(trgt == "Healing #3 "){name = keypress;disp = "8";}
        llMessageLinked(LINK_THIS,DISPLAY_STRING,name, disp);
}
sndkey()
{
        if(tarset == 1){tarset = 0;hudcmd = "Hud_Offe";}
        else if(tarset == 2){tarset = 0;hudcmd = "Hud_Def";} // revisar aqui (>=)
        else{hudcmd = "HUD_Key";}
        integer tarlistlen = llGetListLength(tarnames);
        string listed;string agentkey;
        integer i;
        for (i = 0; i < tarlistlen; i++){listed = llList2String(tarnames, i);
        if(listed == keypress){agentkey = llList2String(targets, i);i = tarlistlen;}}
        keypress = llGetSubString(keypress, 0 ,19);
        if(set == 0){txdata = work_psw + "," + (string)owner
        + "," + hudcmd + "," + keypress + "," + agentkey;
        integer spc_chn = mstr_rxchn + spectrum;llWhisper(spc_chn,txdata);
        integer minih = llGetListLength(huds);minih *= 0.5;
        if(minih == 0){protect_one = agentkey;}
        else if(minih == 1){protect_two = agentkey;}
        else if(minih == 2){protect_three = agentkey;}
        }//llOwnerSay(txdata);}
        else if(keypress == "F2"){skip = 1;}
}
send_request()
{
        string htx = work_psw + "," + (string)keypress + "," + (string)owner + "," + hudcmd;
        llShout(nhud_auxch,htx);llSetLinkPrimitiveParamsFast(6,[PRIM_COLOR,ALL_SIDES,red, 1.0]);
}
brdcst()
{
        integer brdclislen = llGetListLength(broadcast);
        integer i;
        for(i = 0;i < brdclislen; i++)
        {
            string htx = work_psw + "," + llList2String(broadcast, i) + ","
            + (string)owner + "," + "View_Report" +  "," + (string)health
            +  "," +  (string)stam +  "," +  (string)racial +  "," +  (string)status;
            if(htx != lasthtx)
            {
            llShout(nhud_auxch,(htx));lasthtx = htx;
            llSetLinkPrimitiveParamsFast(6,[PRIM_COLOR,ALL_SIDES,red, 1.0]);
            // llWhisper(0, "Last: " + lasthtx);
            // llWhisper(0, "New: " + htx);
            }
        }
}
MH_Bars()
{
        MH_min_size = <0.010123, 0.010123, 0.010000>; // (Initial dimentions) For Z axis in mini Huds bars.
        float MH_fact_PosX = 0.000800; // Pos X Factor for mini huds.
        float MH_fact_SizeZ;
        MH_fact_PosX *= MHBP;
        MH_fact_SizeZ = (MH_fact_PosX * 2);
        MH_loc_pos.y -= MH_fact_PosX;
        MH_min_size.z += MH_fact_SizeZ;
        llSetLinkPrimitiveParamsFast(prim,[PRIM_SIZE,MH_min_size,PRIM_POS_LOCAL,MH_loc_pos]);
}
upd_rac()
{
        cen = llFloor(racial / 100);
        dec = llFloor(racial / 10);
        uni = racial - (dec * 10);
        dec = dec - (cen * 10);
        llSetLinkPrimitiveParamsFast(11, [PRIM_ROT_LOCAL, llList2Rot(digits, uni)]);
        llSetLinkPrimitiveParamsFast(10, [PRIM_ROT_LOCAL, llList2Rot(digits, dec)]);
}
countreset()
{
        integer i;
        for (i = 10; i < 11; i++)
            {
        llSetLinkPrimitiveParamsFast(i, [PRIM_ROT_LOCAL, ( <0.10454, 0.10442, 0.69930, 0.69939>)]);
            }
}
barleds()
{
        if(set == 0){
        vector color_c = green;integer brgth = 1;float alph = 1.0;
        if(bargraph < 5){color_c = pale;brgth = 0;}
        else if(bargraph < 25){color_c = red;}
        else if(bargraph < 50){color_c = yellow;}
        else if(bargraph < 75){color_c = blue;}
        llSetLinkPrimitiveParamsFast
        (prim,[PRIM_COLOR,ALL_SIDES,color_c,alph,PRIM_FULLBRIGHT, ALL_SIDES, brgth]);}
}
blink()
{
        beepcount = 0;
        setime = 90;
        llSetTimerEvent(0.5);
}
upd_bars()
{
                prim = 2;loc_pos = <0.000300, 0.029200, -0.006470>;BP = xpg;MAIN_Bars();
                prim = 3;loc_pos = <0.000300, 0.029200, 0.007100>;BP = stam;MAIN_Bars();
                prim = 4;loc_pos = <0.000300, 0.029200, 0.021600>;BP = health;MAIN_Bars();
                prim = 8;bargraph = stam;barleds();
                prim = 9;bargraph = health;barleds();
}
MAIN_Bars()
{
        min_size = <0.015650, 0.015650, 0.010000>; // (Initial dimentions) For Z axis in main bars.
        float fact_PosX = 0.001160; // Pos X Factor for main bars.
        float fact_SizeZ;
        fact_PosX *= BP;
        fact_SizeZ = (fact_PosX * 2);
        loc_pos.y -= fact_PosX;
        min_size.z += fact_SizeZ;
        llSetLinkPrimitiveParamsFast(prim,[PRIM_SIZE,min_size,PRIM_POS_LOCAL,loc_pos]);
}
show_mhuds()
{
        integer link_e;integer sw3;
        float mov_z = 0.0731;
        float mov_x = 0.0270;
        vector  link_pos;
        list    params;
        link_e = (link + 10);
        link_pos = llList2Vector(llGetLinkPrimitiveParams(link, [PRIM_POS_LOCAL]), 0);
        if(link_pos.z > 0){sw3 = 0;}else{sw3 = 1;}
        integer i;
        for (i = link; i < link_e; i++){
        link_pos = llList2Vector(llGetLinkPrimitiveParams(i, [PRIM_POS_LOCAL]), 0);
        if(sw3 == 0  && sw2 == 1){link_pos.z += -mov_z;link_pos.x += -mov_x;}
        else if(sw3 == 1 && sw2 == 0){link_pos.z += mov_z;link_pos.x += mov_x;}
        params += [PRIM_LINK_TARGET, i,PRIM_POS_LOCAL, link_pos];}
        llSetLinkPrimitiveParamsFast(i, params);
}
openlisten()
{
    llListenRemove(lishnd);
    float FloatValue  = 48637 + llFrand(- 5814963);
    chan = llRound(FloatValue);
    lishnd = llListen(chan, "", owner, "");
    if(menlvl == 0)
        {
            string tarclass;
         if(keypress != "NCS" && keypress != "MHUD")
         {
                string actual_target = "None.";
                if(keypress == "Def"){tarclass = "Healing ";if(protect_one != ""){
                actual_target = "Actual: " + llKey2Name(protect_one) + "\n";}}
                else if(keypress == "Offe"){tarclass = "Offense ";}
                llDialog(owner,"\n" + tarclass + "Target Selection:\n" + actual_target
                + senstat, ["CANCEL", "Clear"] + tarnames,chan);
          }
    //----------------------------------------------------------------------------------
            if(keypress == "NCS"){llPlaySound("34b4fd54-3911-4b1f-7a95-f7c63701bc68", 1.0);
            list menu = ["CANCEL", "Sound off"];string details = "\n" + "NCS HUD Options menu:\n";
            if(clazz == 1)
                {
                    string nobody = "Free.";
                    details += "Active mini-huds:\n";
                    integer minih = llGetListLength(huds);minih *= 0.5;
                    if(minih == 3)
                    {
                        menu += ["Clear 1", "Clear All"];
                        details += "M-Hud # 1: " + llList2String(huds, 1) + "\nM-Hud # 2: "
                        + llList2String(huds, 3) + "\nM-Hud # 3: " + llList2String(huds, 5);
                    }
                    else if(minih >= 1)
                    {
                        menu += ["Add HUD", "Clear 1", "Clear All"];
                        details += "M-Hud # 1: " + llList2String(huds, 1);
                        if(minih == 2){details += "\nM-Hud # 2: " + llList2String(huds, 3) +  "\nM-Hud # 3: " + nobody;}
                        else{details += "\nM-Hud # 2: " + nobody + "\nM-Hud # 3: " + nobody;}
                    }
                    else if(minih == 0)
                    {
                        menu += ["Add HUD", "Clear 1", "Clear All"];
                        details += "M-Hud # 1: " + nobody + "\nM-Hud # 2: "
                        + nobody + "\nM-Hud # 3: " + nobody;
                    }
                }
                    llDialog(owner,details,menu,chan); menlvl = 4;
                }
            else if(keypress == "MHUD")
                {
                    integer minih = llGetListLength(huds);minih *= 0.5;
                    tarset = 0;
                    if(minih == 0){tarclass = "Healing #1 ";}
                    else if(minih == 1){tarclass = "Healing #2 ";}
                    else if(minih == 2){tarclass = "Healing #3 ";}
                    llDialog(owner,"\n" + tarclass + "Target Selection:\n" + senstat,
                    ["CANCEL", "Clear"] + tarnames,chan); menlvl = 4;
                }
        }
        //----------------------------------------------
    else if(menlvl == 1)
        {
            llPlaySound("34b4fd54-3911-4b1f-7a95-f7c63701bc68", 1.0);
            if(owner == crt)
                {
                    llDialog(owner,"\n" + "Select the bar for color change:",
                    ["CANCEL", "DEFAULTS", "HEALTH", "STAMINA", "XP BAR", "SHOW MHUD"],chan);
                    menlvl = 2;
                }
            else
                {
                    llOwnerSay("Really Nigga ?");
                }
        }
    else if(menlvl == 2 && owner == crt){llTextBox(owner, " Enter color vector for " + txtb + " bar", chan);menlvl = 3;}
}
default
{
    state_entry()
    {
        llSetLinkPrimitiveParamsFast
        (2,[PRIM_COLOR,ALL_SIDES,<1, 1, 0.79>, 1.0]);
        llSetLinkPrimitiveParamsFast
        (3,[PRIM_COLOR,ALL_SIDES,<0.224, 0.800, 0.800>, 1.0]);
        llSetLinkPrimitiveParamsFast
        (4,[PRIM_COLOR,ALL_SIDES,<1.0,0.1,0.1>, 1.0]);
        ini();
    }
    attach(key attached)
    {
        if(attached != NULL_KEY)
            {
                ini();
            }
        else
        {
            orphan = 1;
            llListenRemove(lh);
            llListenRemove(lhaux);
        }
    }
     touch_start(integer total_number)
    {
        if(llDetectedLinkNumber(0) == 1)
        {
        vector touchUV = llDetectedTouchUV(0);
        integer col = (integer) (touchUV.x * numberOfColumns);
        integer row    = (integer) (touchUV.y * numberOfRows);
        integer cell   = row * numberOfColumns + col;//llOwnerSay("Celda: " + (string)cell);
        integer bcol;integer brow;
        integer click;
        menlvl = 0;
        //--------------------------------------------------------
        if(row >19 && row <38 && col >2 && col <24){brow = 23;bcol = 224;}
        else if(row >6 && row <15){brow = 3;}
        else if(row >18 && row <27){brow = 2;}
        else if(row >28 && row <38){brow = 1;}
        //--------------------------------------------------------
        if(brow == 3){if(col >5 && col <11){bcol = 1;}
        else if(col >11 && col <18){bcol = 2;}
        else if(col >17 && col <25){bcol = 3;}
        else if(col >25 && col <34){bcol = 4;}
        else if(col >33 && col <41){bcol = 5;}
        else if(col >40 && col <48){bcol = 6;}}
        //--------------------------------------------------------
        else if(col >25 && col <32){bcol = 7;}
        else if(col >30 && col <37){bcol = 8;}
        else if(col >36 && col <42){bcol = 9;}
        else if(col >41 && col <50){bcol = 10;}
       // llOwnerSay("Columna: " + (string)col + " Renglon: " + (string)row +
      //  " Vertical: " + (string)bcol + " Horizontal: " + (string)brow);
        //--------------------------------------------------------
        if(bcol == 1 && brow == 3){keypress = "Def";skip = 1;scan();}
        else if(bcol == 2 && brow == 3){keypress = "Offe";skip = 1;scan();}
        else if(bcol == 3 && brow == 3){keypress = "RPN";skip = 1;click = 1;menlvl = 1;openlisten();}//llOwnerSay("Really Nigga ?");}
        else if(bcol == 4 && brow == 3){keypress = "Set";if(set == 0){set = 1;skip = 1;
        llOwnerSay("Choose a function key on the HUD to assign.");blink();}
        else{set = 0;skip = 0;llOwnerSay("Hot keys set mode is now off.");}}
        else if(bcol == 5 && brow == 3){keypress = "Web";skip = 1;
        llLoadURL(llGetOwner(), "NCS Support", "https://www.ncs-sl.com/");}
        else if(bcol == 6 && brow == 3){keypress = "Pow";sndkey();}
        //--------------------------------------------------------
        else if(bcol == 7 && brow == 1){keypress = "F2";sndkey();llPlaySound("6613b195-acce-c924-31bf-057f2c3469f8", 1.0);click = 1;
        if(set == 1){llOwnerSay("F2 is for menu, can't be changed!");}}
        else if(bcol == 7 && brow == 2){keypress = "F6";sndkey();llPlaySound("6613b195-acce-c924-31bf-057f2c3469f8", 1.0);click = 1;}
        else if(bcol == 8 && brow == 1){keypress = "F3";sndkey();llPlaySound("e192bdb0-c2b2-50c0-0979-cf014e32d84b", 1.0);click = 1;}
        else if(bcol == 8 && brow == 2){keypress = "F7";sndkey();llPlaySound("10e27159-4aa6-4df9-ad83-e332ef6c8e86", 1.0);click = 1;}
        else if(bcol == 9 && brow == 1){keypress = "F4";sndkey();llPlaySound("b5351ecf-d20a-f707-7841-079b4a18ebc2", 1.0);click = 1;}
        else if(bcol == 9 && brow == 2){keypress = "F8";sndkey();llPlaySound("d8277015-cbb6-97ca-9e70-b4874e686b44", 1.0);click = 1;}
        else if(bcol == 10 && brow == 1){keypress = "F5";sndkey();llPlaySound("ed5ec3c0-3189-ac25-69c8-e0f70ebc297e", 1.0);click = 1;}
        else if(bcol == 10 && brow == 2){keypress = "F9";sndkey();llPlaySound("573d9ac0-7cbd-b715-b70c-ef598790562c", 1.0);click = 1;}
        //else if(bcol == 224 && brow == 23){keypress = "NCS";skip = 1;click = 1;openlisten();}
        else{click = 1;skip = 1;keypress = "";llPlaySound("b753b6e0-0207-a7d3-c4e7-322a3bc3e0ec",1.0);}
        if(click == 0){llPlaySound("4de2e596-9551-119b-5eaf-d349968b116d",1.0);}
       // llOwnerSay("\nX,Y: "+(string)row+", "+(string)col+
       //  "\n -- Cell: "+(string)cell+"\nKey: "+(string)keypress);
        if(set == 1 && skip == 0){set = 0;txdata = work_psw + "," + (string)owner
        + "," + "Set_Key" + "," + keypress;integer spc_chn = mstr_rxchn + spectrum;
        llWhisper(spc_chn,txdata);}
        skip = 0;
        }
        else if(llDetectedLinkNumber(0) == 22)
        {
            list params = llGetLinkPrimitiveParams(26,[PRIM_POS_LOCAL, PRIM_SIZE]);
            string data1 = llList2String(params,0);
            string data2 = llList2String(params,1);
            llOwnerSay((string)data1 + "," + (string)data2);
            params = llGetLinkPrimitiveParams(25,[PRIM_POS_LOCAL, PRIM_SIZE]);
            data1 = llList2String(params,0);
            data2 = llList2String(params,1);
            llOwnerSay((string)data1 + "," + (string)data2);
        }
        else if(llDetectedLinkNumber(0) == 32)
        {

        }
        else if(llDetectedLinkNumber(0) == 42)
        {

        }
    }
    listen(integer chnl, string name, key id, string mesg)
    {
        if(chnl == nhud_rxchn)
        {//llOwnerSay(mesg);
           // llOwnerSay((string)llKey2Name(llGetOwnerKey(id)) + ", " + (string)id);
            if(orphan == 1){if(owner == llGetOwnerKey(id)){llListenRemove(lh);orphan = 0;
            lh = llListen(nhud_rxchn,name,id,"");}}
            list data = llCSV2List(mesg);
            if(llList2String(data,0) == work_psw && llList2String(data,1) == owner)
            {
               // llSay(0, "Status: " + llList2String(data,7));
                string cmd = llList2String(data,2);
                if(cmd == "Upd_Gauges"){
                integer iheal = (integer)llList2String(data,3);
                integer istam = (integer)llList2String(data,4);
                racial = (integer)llList2String(data,5);upd_rac();
                xpg = (integer)llList2String(data,6);
                status = (integer)llList2String(data,7);
                clazz = (integer)llList2String(data,8);//llOwnerSay("Clase: " + (string)clazz);
                stam = llRound(istam);
                health = llRound(iheal);
                integer brdclislen = llGetListLength(broadcast);
                if(brdclislen != 0){brdcst();}
                upd_bars();}
               // llOwnerSay(cmd);
            //-----------------------------------------------------------------------------------
                if(cmd == "Resync"){string hcmsg = llList2String(data,3);
                string unscramb = llBase64ToString(llXorBase64(hcmsg, llStringToBase64(seeds_0)));
                spectrum = (integer)unscramb;}
            //------------------------------------------------------------------------------------
                else if(cmd == "offe_H"){llPlaySound("98f81946-00c2-6710-0808-b3e56d919186",0.5);}
                else if(cmd == "supp_H"){llPlaySound("4bfdba3a-57e1-bf00-304e-bcb6ba1ddb6c",0.5);}
                else if(cmd == "heal_H"){llPlaySound("3e2556e6-7ff7-ea71-325c-aede5f51ae70",0.5);}
                else if(cmd == "Hud_ShowBuff"){llSetLinkPrimitiveParamsFast
                (18,[PRIM_COLOR,ALL_SIDES,<1,1,1>, 1.0,PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);}
                else if(cmd == "Hud_Armor"){llSetLinkPrimitiveParamsFast
                (17,[PRIM_COLOR,ALL_SIDES,<1,1,1>, 1.0,PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);}
                else if(cmd == "Hud_Hot"){llSetLinkPrimitiveParamsFast
                (16,[PRIM_COLOR,ALL_SIDES,<1,1,1>, 1.0,PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);}
                else if(cmd == "Hud_HideHot"){llSetLinkPrimitiveParamsFast
                (16,[PRIM_COLOR,ALL_SIDES,<1,1,1>, 0.0,PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);}
                else if(cmd == "Hud_Buff"){llSetLinkPrimitiveParamsFast
                (18,[PRIM_COLOR,ALL_SIDES,<1,1,1>, 1.0,PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);}
                else if(cmd == "Hud_HideArmor0"){llSetLinkPrimitiveParamsFast
                (17,[PRIM_COLOR,ALL_SIDES,<1,1,1>, 0.0,PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);}
                else if(cmd == "Hud_HideArmor"){llSetLinkPrimitiveParamsFast
                (17,[PRIM_COLOR,ALL_SIDES,<1,1,1>, 0.0,PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);}
                else if(cmd == "Hud_HideBuff"){llSetLinkPrimitiveParamsFast
                (18,[PRIM_COLOR,ALL_SIDES,<1,1,1>, 0.0,PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);}
                else if(cmd == "Hud_Poison"){llLoopSound("f4aa7471-aae1-c84b-43b4-7fc0b1412f10", 1.0);}
                else if(cmd == "Hud_HidePois"){llStopSound();}
                else if(cmd == "Hud_CTargets"){llMessageLinked(LINK_THIS,DISPLAY_STRING,"", "0");
                llMessageLinked(LINK_THIS,DISPLAY_STRING,"", "1");}
                else if(cmd == "Hud_Targets"){string defet = (string)llList2String(data,3);
                string offet = (string)llList2String(data,4);//protect_one = defet;
                llMessageLinked(LINK_THIS,DISPLAY_STRING,defet, "0");
                llMessageLinked(LINK_THIS,DISPLAY_STRING,offet, "2");
              //  llMessageLinked(LINK_THIS,DISPLAY_STRING,defet, "2");
              //  llMessageLinked(LINK_THIS,DISPLAY_STRING,offet, "3");
              //  llMessageLinked(LINK_THIS,DISPLAY_STRING,defet, "4");
              }
                else if(cmd == "Hud_States"){}
            }
        }
        else if(chnl == chan)
        {
            llListenRemove(lishnd);
            string msg = llToLower(mesg);
            if(msg == "cancel"){scn = 0;msg = "";keypress = "";menlvl = 0;tarset = 0;}
        //------------------------------------------------------------------
        else if(menlvl == 0)
                {
                    if(keypress == "Def"){trgt = "Healing ";tarset = 2;}
                    else{trgt = "Offense ";tarset = 1;}
                    if(msg == "clear"){scn = 0;mesg = "";
                    (trgt + "target has been cleared.");
                    keypress = "";sndobj();sndkey();}
                   // llMessageLinked(LINK_THIS,DISPLAY_STRING, "", "2");}
                    if(scn == 1){scn = 0;keypress = mesg;sndobj();sndkey();}
                }
        //------------------------------------------------------------------
        else if(menlvl == 2)
                {
                    if(msg == "xp bar"){prim = 2;txtb = "Xp";openlisten();}
                    else if(msg == "stamina"){prim = 3;txtb = "Stam";openlisten();}
                    else if(msg == "health"){prim = 4;txtb = "HP";openlisten();}
                    else if(msg == "defaults"){colordf();}
                    else if(msg =="show mhud"){link = 22;show_mhuds();}
                }
        else if(menlvl == 3)
                {
                    if((vector)msg != ZERO_VECTOR){vcolors = (vector)msg;colorch();}
                }
         //------------------------------------------------------------------
        else if(menlvl == 4)
                {
                    if(scn == 1){scn = 0;keypress = mesg;tarset = 0;
                    integer minih = llGetListLength(huds);minih *= 0.5;
                    sndobj();
                   sndkey();
                   if(minih == 0){keypress = protect_one;}
                   else if(minih == 1){keypress = protect_two;}
                   else if(minih == 2){keypress = protect_three;}
                    hudcmd = "View_Request";send_request();
                    llOwnerSay("Your remote HUD view request has been sent to: " + keypress);}
                    else if(msg == "add hud"){tarset = 3;scan();}
                   // else if(msg == "clear"){scn = 0;mesg = "";
                    //llOwnerSay(trgt + "target has been cleared.");
                  //  keypress = "";sndobj();tarset = 0;}//sndkey();}
                }
         else if(menlvl == 5)
                {
                    string remoteclient = llKey2Name(requester);
                    if(msg == "yes")
                    {
                    string htx = work_psw + "," + (string)requester + "," + (string)owner + "," + "Request_View_Accept";
                    llShout(nhud_auxch,htx);llOwnerSay("You accepted the HUD view request from " + remoteclient);menlvl = 0;
                    if(llListFindList(broadcast, (list)requester) == -1){broadcast += requester;requester = "";}
                    brdcst();
                    //else{llWhisper(0, "Authoriztion sent but was not duplicated in the clients list.");}
                    }
                    else if(msg == "no")
                    {
                    string htx = work_psw + "," + (string)requester + "," + (string)owner + "," + "Request_View_Denied";
                    llShout(nhud_auxch,htx);llOwnerSay("You denied the HUD view request from " + remoteclient);
                    requester = "";menlvl = 0;
                    }
                }
         //------------------------------------------------------------------
        }
        else if(chnl == nhud_auxch)
        {
            //llOwnerSay((string)llKey2Name(llGetOwnerKey(id)) + ", " + (string)id);
            list data = llCSV2List(mesg);
            if(llList2String(data,0) == work_psw && llList2String(data,1) == owner)
            {
                requester = llList2String(data,2);
                string remoteclient = llKey2Name(requester);
                integer minih = llGetListLength(huds);minih *= 0.5;minih += 2;
                string cmd = llList2String(data,3);
                if(cmd == "View_Request")
                {
                    llPlaySound("d0d54689-bc04-edc7-cc78-ecec478a5e09", 1.0);
                     menlvl = 5;openlisten();
                    llDialog(owner,"\n" + "NCS HUD Remote feature:\n\n" + remoteclient
                    + "Sent YOU a request to SEE YOUR HUD\nDo you Aceept?",
                    ["NO", "YES"],chan);
                }
                else if(cmd == "Request_View_Accept")
                {
                    if(minih == 2){minih = 4;link = 22;}
                    else if(minih == 3){minih = 6;link = 32;}
                    else if(minih == 4){minih = 8;link = 42;}
                    llMessageLinked(LINK_THIS,DISPLAY_STRING,remoteclient, (string)minih);
                    llPlaySound("d5e3f884-49f4-d7b8-df65-cffa996bf2c7", 1.0); //notify yes
                    huds += [requester, remoteclient];sw2 = 1;show_mhuds();
                    llOwnerSay("Player " + remoteclient + " acceped your HUD view request!");
                }
                else if(cmd == "Request_View_Denied")
                {
                    llPlaySound("25e78696-d5c0-431e-020c-bcd51c9ebd81", 1.0); //notify no
                    llOwnerSay("Player " + remoteclient + " rejected your HUD view request!");
                }
                else if(cmd == "View_Report")
                {
                    llSetLinkPrimitiveParamsFast(5,[PRIM_COLOR,ALL_SIDES,green, 1.0]); // RX Led
                    integer pasign = llListFindList(huds, (list)requester);
                    if(pasign != -1)
                    {
                    integer HP = (integer)llList2String(data,4); // Health points.
                    integer SP = (integer)llList2String(data,5); // Stamina points.
                    integer b = (integer)llList2String(data,7); // remote status effects (Bit oriented).
                    integer a;
                    integer and;
                    integer face;
                    integer facecount;
                    string bin;
                    list faces = [3,7,4,6,1];
                    if(pasign == 0)
                        {
                            prim = 23;bargraph = SP;barleds();prim = 24;bargraph = HP;barleds();
                            prim = 25;MH_loc_pos = <-0.003800, 0.273000, -0.067700>;MHBP = SP;MH_Bars();
                            prim = 26;MH_loc_pos = <-0.003800, 0.273000, -0.057400>;MHBP = HP;MH_Bars();
                        }
                    else if(pasign == 2)
                        {
                            prim = 33;bargraph = SP;barleds();prim = 34;bargraph = HP;barleds();
                            prim = 35;MH_loc_pos = <-0.003800, 0.068500, -0.067700>;MHBP = SP;MH_Bars();
                            prim = 36;MH_loc_pos = <-0.003800, 0.068500, -0.057400>;MHBP = HP;MH_Bars();
                        }
                    else if(pasign == 4)
                        {
                            prim = 43;bargraph = SP;barleds();prim = 44;bargraph = HP;barleds();
                            prim = 45;MH_loc_pos = <-0.003800, -135700, -0.067700>;MHBP = SP;MH_Bars();
                            prim = 46;MH_loc_pos = <-0.003800, -135700, -0.057400>;MHBP = HP;MH_Bars();
                        }
                    prim += 3;link = (prim - 7);
                    vector link_pos = llList2Vector(llGetLinkPrimitiveParams(link, [PRIM_POS_LOCAL]), 0);
                    if(link_pos.z < 0)
                        {
                        for (a = 16; a > 0; a *= 0.5)
                            {
                            and = (b & a);if(and > 0){and = 1;}
                            bin += (string)and;
                            face = (integer)llList2String(faces,facecount);
                            llSetLinkAlpha(prim, and, face);
                            facecount +=1;if(facecount >= 5){facecount = 5;a = 0;}
                            }
                        }
                    }
                  ///  report = data;//llOwnerSay(llList2CSV(report));
                }
                else if(requester ==  "NCS_MTR_DTH"){ini();}
                    else if(requester == "NCS_MTR_RBT")
                        {
                        orphan = 1;
                        llListenRemove(lh);
                        llListenRemove(lhaux);
                        llListenRemove(lishnd);
                        lhaux = llListen(nhud_auxch,"","","");
                        lh = llListen(nhud_rxchn,"","","");
                        mtrpoll();
                        }
            }
        }
        if(chnl == serv_rxchn)
        {
            string clean = llBase64ToString(llXorBase64(mesg, llStringToBase64(seeds_0)));
            list data = llCSV2List(clean);
            string passw = llList2String(data, 0);
            if(passw == apipass)
            {
                if((key)llList2String(data, 1) == llGetKey())
                {
                    spectrum = (integer)llList2String(data, 2);
                    llListenRemove(lsn_handler);
                    mtrpoll();
                }
            }

        }
    }
    link_message(integer sender, integer channel, string data, key id)
    {
        if(id == "Gauges!" && channel == 942969)
        {
            if(data == "Hbeat"){llSetLinkPrimitiveParamsFast(5,[PRIM_COLOR,ALL_SIDES, <0.1, 0.3, 0.1>, 1.0]);}
            else if(data == "Hbeat2"){llSetLinkPrimitiveParamsFast(6,[PRIM_COLOR,ALL_SIDES, <0.3, 0.1, 0.1>, 1.0]);}
        }
    }
    timer()
    {
        if(set == 1){vector color_c = pale;integer brgth = 0;
        float alph = 1.0;if(ledsw == 0){ledsw = 1;color_c = pale;
        brgth = 0;alph = 1.0;}else{ledsw = 0;prim = 9;color_c =
        green;brgth = 1;alph = 1.0;beepcount += 1;if(beepcount > 3){
        llPlaySound("4bbf5e87-22a5-5f0f-0e9c-83dcdbae68c0", 0.3);}}
        llSetLinkPrimitiveParamsFast
        (prim,[PRIM_COLOR,ALL_SIDES,color_c,alph,PRIM_FULLBRIGHT, ALL_SIDES, brgth]);}
        else{llSetTimerEvent(0);setime = 0;barleds();beepcount = 0;}
        if(setime > 0){setime -= 1;if(setime <= 0){setime = 0;set = 0;ledsw = 0;
        llOwnerSay("Set hot keys time expired !");llSetTimerEvent(0);barleds();}}
    }
    sensor(integer num)
    {
        targets = [];
        tarnames = [];
        senstat = "";
        integer i;
        if(num > 10)
            num = 10;
        for(i=0;i<num;i++)
        {
            if(tarset < 2)
            {
                targets += [llDetectedKey(i)];
                tarnames += [llGetSubString(llDetectedName(i), 0, 19)];
            }
            else if(llDetectedGroup(i))
            {
              if(llListFindList(huds,(list)llDetectedKey(i)) == -1)
                {
                targets += [llDetectedKey(i)];
                tarnames += [llGetSubString(llDetectedName(i), 0, 19)];
                }
            }
        }
        if(tarset > 2){keypress = "MHUD";}
        menlvl = 0;openlisten();
    }
    no_sensor()
    {
            llOwnerSay("No One In Range !");
            targets = [];
            tarnames = [];
            scn = 0;
            senstat = "No One In Range !";
            if(tarset > 2){keypress = "MHUD";}
            menlvl = 0;openlisten();
    }
     changed(integer mask)
    {if(mask & CHANGED_OWNER){llListenRemove(lhaux);llListenRemove(lh);}}//llResetScript();}}
}