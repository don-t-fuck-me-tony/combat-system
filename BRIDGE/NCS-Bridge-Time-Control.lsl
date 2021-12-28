float time;
integer tcomp;
integer lishnd;
integer chan;
integer menup;
integer menlvl;
key toucher;
vector color = <1.0, 1.0, 1.0>;
integer ringglow_R;
integer relstat;
integer rxchan = -1999996429;
integer txchan = -1999999429;
integer relay_st = 1;
float ringglow;
key owner;
key relay;
key userping;
key http_request_id_xp;
key http_request_id_register;
string txpass = "NCSv1.0Ogaleicrum9429¡";
string rxpass = "NCSv1.0Murcielago9429!";
string mctr_psw = "01!hWelcr*dNCSv1.05906";
string txdata;
string bridge;
string sim;
string host;
string txt;
string extratxt;
list users;
integer avscan;
integer scantime;
integer scn_TO;
integer tictime = 240;
integer xptime;
integer ticks = 8;
integer comtime = 20; //28800; // randomize new com channels offset each 28800 secs. (8 hours)
integer unixt;
integer spectrum; // variable coms offset
integer disabled = 0;
string owname;
string prefixurl = "https://www.ncs-sl.com"; //"https://ncs-dev.herokuapp.com";
string url;
//list buttons = ["CANCEL", "Chng URL", "Set DXP", "-", "-", "-"];
list buttons = ["CANCEL"];
playersupd()
{
    list avisInRegion = llGetAgentList(AGENT_LIST_REGION, []);
    integer numOfAvis = llGetListLength(avisInRegion);
    key client;
    integer i;
    for (i = 0; i < numOfAvis; i++)
        {
            client = llList2String(avisInRegion, i);
            if(llGetAgentSize(client) !=  ZERO_VECTOR)
                {
            txdata = (string)client + "," + "Ping";
           // string xmitt = txpass + "," + txdata;
            llMessageLinked(LINK_THIS,89898989, txdata, client);
            //llRegionSayTo(client,txchan,xmitt);
                }
        }
}
ini()
{
    users = [];
    xptime = tictime;
    extratxt = "Normal";
    llMessageLinked(LINK_THIS, 134, prefixurl, "Shred_URL");
    playersupd();
    upd_txt(JSON_NULL);
    llSetTimerEvent(0.5);
   // llMessageLinked(LINK_THIS, 24021955, "", "REGISTER_SUCCESS"); // QUITAR **** !!!!!!!!!
}
upd_txt(string errorMessage)
{
    if (errorMessage != JSON_NULL) {
        vector errorColor = <1.0, 0.2, 0.2>;
        llSetText(errorMessage, errorColor, 1.0);
        return;
    }
    integer B;
    integer A = tictime / 2;if(A > 60){A = llFloor((tictime / A));}else{B = tictime / (A * 60); A = 0;}
    string ticle = (string)A + ":";if(B < 10){ticle += "0" + (string)B;}else{ticle += (string)B;}
    txt = bridge + "\n Bridge Owner: " + owname + "\nSim Name: " + sim +
    "\nActual XP Tic: " + (string)ticks + " | Tic Frequency: " +
    ticle + " Mins." + "\nBridge state: " + extratxt + "\nActive Users: " + (string)llGetListLength(users) +
    " | Users detected: " + (string)avscan;
    llSetText(txt, color, 1.0);
}
register()
{
    bridge = llGetObjectName();
    owner = llGetOwner();
    owname = llKey2Name(owner);
    relay = llGetKey();
    sim = llGetRegionName();
    url = prefixurl + "/api/relay/";
   // url = "https://immense-river-36848.herokuapp.com/api/relay/"; // production !!!
   
    string Json;
   
   if (getRelayId() != JSON_NULL) {
       Json =  "{\"region_name\":\"" + sim + "\",\"owner_id\":\"" + (string)llGetOwner() + "\"" + ",\"status\":" + (string)relay_st + ",\"relay_id\":\"" + (string) getRelayId() + "\"}";
    } else {
       Json =  "{\"region_name\":\"" + sim + "\",\"owner_id\":\"" + (string)llGetOwner() + "\"" + ",\"status\":" + (string)relay_st + "}";
    }
    http_request_id_register = llHTTPRequest(url, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/json"], Json);
}
pingusers()
{
    scn_TO = 4;
    extratxt = "Scaning...";
    avscan = 0;upd_txt(JSON_NULL);
    key client;
    integer i;
    integer userlistlen = llGetListLength(users);
    for (i = 0; i < userlistlen; i++)
        {
    client = llList2String(users, i);
    txdata = (string)client + "," + "Ping";
  //  string xmitt = txpass + "," + txdata;
    llMessageLinked(LINK_THIS,89898989, txdata, client);
   // llRegionSayTo(client,txchan,xmitt);
        }
}
send_xp()
{
    string relay_id = getRelayId();
    if (relay_id == JSON_NULL || relay_id == JSON_INVALID) return;
    url = prefixurl + "/relay/" + (string) getRelayId() + "/xp";
    integer userlistlen = llGetListLength(users);
    string Json =  "{\"users\":[";
    integer i;
    for (i = 0; i < userlistlen; i++)
        {
            Json += "\"" + llList2String(users, i);Json += "\"";
            if(i != (userlistlen - 1)){Json += ",";}
        }
    Json += "],\"xp\": " + (string)ticks + "}";
    http_request_id_xp = llHTTPRequest(url, [HTTP_METHOD, "PUT", HTTP_MIMETYPE, "application/json"], Json);
   // llSay(0, "Json to send: " + Json);
}
Syncxpmeters(string relayData)
{
    string isRelayEnabled = llJsonGetValue(relayData, ["enabled"]);
    if (isRelayEnabled == JSON_FALSE) {
        resetRelay();
        return;
    }
    txdata = "BrDcTTT";
    string xmitt = txpass + "," + mctr_psw + "," + txdata;
    llMessageLinked(LINK_THIS,89898996, xmitt, "Brdcst");
   // llRegionSay(txchan,xmitt);
}

resetRelay() {
    string xmitt = (mctr_psw + "," + (string)owner + "," + "allreset" + "," + (string)owner);
    llMessageLinked(LINK_THIS,89898996, xmitt, "Brdcst");
    // llRegionSay(txchan, xmitt);
    llMessageLinked(LINK_THIS, 134, "", "RESET");
    llResetScript();
}
users_xp()
{
    key player;
    integer i;
    integer userlistlen = llGetListLength(users);
    for (i = 0; i < userlistlen; i++)
        {
        player = llList2Key(users, i);
        if(llGetAgentSize(player) == ZERO_VECTOR){users = llDeleteSubList(users, i, i);}
        }
    pingusers();
}
openlisten()
{
    llListenRemove(lishnd);
    float FloatValue  = 48637 + llFrand(- 5814963);
    chan = llRound(FloatValue);
    lishnd = llListen(chan, "", toucher, "");menup = 1;
    if(menlvl == 0)
    {
    llDialog(toucher,"NCS ADMIN MENU COMING SOON",buttons,chan);
    }
    else if(menlvl == 1)
    {
        llTextBox(toucher, "Actual URL: " + prefixurl + "\nPaste new URL here and click 'Send'", chan);
        menlvl = 2;
    }
}

string getRelayId() {
    string id = llGetObjectDesc();
    
    if (id == "???")
        return JSON_NULL;
    else
        return id;
}

default
{
    state_entry()
    {
        llSetLinkPrimitiveParamsFast(4, [PRIM_COLOR, ALL_SIDES, <0.498, 0.859, 1.000>, 1.0,
        PRIM_FULLBRIGHT,ALL_SIDES, FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
        llSetLinkPrimitiveParamsFast(3, [PRIM_COLOR, ALL_SIDES, <0.498, 0.859, 1.000>, 1.0,
        PRIM_FULLBRIGHT,ALL_SIDES, FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
        ini();register();
    }
    on_rez(integer startup_param)
    {
       register();
    }
    touch_start(integer total_number)
    {
        toucher = llDetectedKey(0);
        openlisten();
    }
     listen(integer chnl, string name, key id, string mesg)
    {
        llListenRemove(lishnd);
        if(toucher == "fdcd2886-4a08-4a56-bc09-30c5f362817f" || toucher == owner || toucher == "a430e426-08c2-4532-a1e3-813e468e318b")
        {
            if(chnl == chan)
            {
                if (mesg == "Chng URL")
                {
                    menlvl = 1;
                    openlisten();
                }
                 if (menlvl == 2)
                {
                    if(mesg != "")
                    {
                    menlvl = 0;
                    prefixurl = mesg;
                    llMessageLinked(LINK_THIS, 134, prefixurl, "Shred_URL");
                    }
                }
            }
        }
    }
    link_message(integer sender, integer num, string str, key id)
        {
        if(str == "P_ACK" && num == 1){avscan += 1;scn_TO = 4;integer index = llListFindList(users, [id]);
        if(index == -1){users += id;}}
        else if(str == "ADD" && num == 1){integer index = llListFindList(users, [id]);
        if(index == -1){users += id;avscan += 1;}}
        else if(str == "REMOVE" && num == 1){integer index = llListFindList(users, [id]);
        if(index != -1){users = llDeleteSubList(users, index, index);avscan -= 1;}}upd_txt(JSON_NULL);
        if(str == "NLP" && num == 1){integer index = llListFindList(users, [id]);
        if(index != -1){users = llDeleteSubList(users, index, index);avscan -= 1;}}upd_txt(JSON_NULL);
        if(id == "Master" && num == 0){if(str == "TX"){llSetLinkPrimitiveParamsFast
        (4, [PRIM_COLOR, ALL_SIDES, <0.498, 0.859, 1.000>, 1.0,PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
        PRIM_GLOW, ALL_SIDES, 1.0]);}else if(str == "RX"){llSetLinkPrimitiveParamsFast
        (3, [PRIM_COLOR, ALL_SIDES, <0.498, 0.859, 1.000>, 1.0,PRIM_FULLBRIGHT, ALL_SIDES, TRUE,
        PRIM_GLOW, ALL_SIDES, 1.0]);}}llSetLinkPrimitiveParamsFast
        (1, [PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 0.1]);
        if(ringglow_R == 0){ringglow += 0.1;if(ringglow > 1){ringglow = 1;ringglow_R = 1;}}
        else{ringglow -= 0.1;if(ringglow < 0){ringglow = 0;ringglow_R = 0;}}
        llSetLinkPrimitiveParamsFast(3, [PRIM_COLOR, ALL_SIDES, <1.0,1.0,1.0>, 1.0,
        PRIM_FULLBRIGHT,ALL_SIDES, FALSE, PRIM_GLOW, ALL_SIDES, ringglow]);
        llSetLinkPrimitiveParamsFast(4, [PRIM_COLOR, ALL_SIDES, <0.498, 0.859, 1.000>, 1.0,
        PRIM_FULLBRIGHT,ALL_SIDES, FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
        llSetLinkPrimitiveParamsFast(1, [PRIM_COLOR, ALL_SIDES, <1.000, 1.000, 1.000>, 0.5]);
    }
     http_response(key request_id, integer statusrq, list metadata, string body)
    {
        if(request_id == http_request_id_xp && statusrq == 200){Syncxpmeters(body);}
        if(request_id == http_request_id_register) {
            if (statusrq == 200) {
                string relayData = llJsonGetValue(body, ["relay"]);
                string enabled = llJsonGetValue(relayData, ["enabled"]);
                
                if (enabled == JSON_FALSE) {
                    disabled = 1;
                    llSetTimerEvent(tictime);
                    string errorMessage = "Service disabled";
                    upd_txt(errorMessage);
                    return;
                }

                llMessageLinked(LINK_THIS, 24021955, "", "REGISTER_SUCCESS");
                llSetObjectDesc(llJsonGetValue(relayData, ["relay_id"]));
                llOwnerSay("You can access your admin panel at " + (string) prefixurl + "/view/admin/auth?uid=" + (string) llGetOwner());
                llOwnerSay(llJsonGetValue(body, ["admin"]));
                ini();
            } else {
                 string errorMessage = llJsonGetValue(body, ["message"]);
                upd_txt(errorMessage);
                llOwnerSay(errorMessage);
            }
        }
    }
    
    timer()
    {
        integer offset = 1;
        tcomp +=1;if(tcomp > 5){time = llGetAndResetTime();
        integer synch = llRound(time) * 2;offset = (synch - tcomp) + 1;
        tcomp = 0;if(offset < 1){offset = 1;}}
    //--------------------------------------------------------------------        
        if (disabled > 0) {
            // When Bridge is disabled by admin we check on timer if status has changed
            resetRelay();
        }
    //------------- XP timer and spectrum chanel jump control -------------
        if (xptime > 0){xptime -= offset;if(xptime <= 0){xptime = tictime;users_xp();send_xp();
        integer utime = llGetUnixTime();if(unixt < utime){llMessageLinked(LINK_THIS, 134, (string)spectrum, "Shred_SPECT");unixt = llGetUnixTime() + comtime;}}} //llOwnerSay("Unix Time: " + (string)utime);llOwnerSay("Unix Time Stored: " + (string)unixt);
    //---------------------------------------------------------------------
        if (scantime > 0){scantime -= offset;if(scantime <= 0){scantime = 60;scn_TO = 4;pingusers();}}
        if (scn_TO > 0){scn_TO -= offset;if(scn_TO <= 0){scn_TO = 0;extratxt = "Normal";upd_txt(JSON_NULL);}}
    }
    changed(integer mask)
    {
        if(mask & CHANGED_OWNER){llResetScript();}
    }
}