key owner;
key http_request_id;
integer http_state;
integer err_flag;
integer boot;
integer retry;
integer progress;
integer online;
integer secs;
integer tsw;
integer req_flag;
string S_brand = "Novelty Combat System";
string Bstate;
string pret;
string post;
string owname;
string ftext;
string prefixurl = "https://www.ncs-sl.com"; // "https://ncs-dev.herokuapp.com";
string url;
string txt;
//------------------------------------------------------------------------------------------------------------------------------------
integer xptics;
integer xperience;
key RX_id;
key serv_id;
integer lsn_handler;
integer serv_txchn = -1999996429;
integer serv_rxchn = -1999999429;
integer nhud_rxchn = -1999994906; // hud channel.
string txdata;
string serv_psw = "NCSv1.0Murcielago9429!";
string metr_psw = "NCSv1.0Ogaleicrum9429¡";
string mctr_psw = "01!hWelcr*dNCSv1.05906";
string work_psw = "QWERTY!";
string serv_msg;
string seeds_0 = "LfqZg9lqDejaDo22DMO0tnQeWK4lus9ztpkFHUwT"; // Basic common seeded key for data exchange.
string seeds_1 = "ZPKlHpA3LnT1zZgnRj9q6ootfBx8kvIU2PKtEA6g"; // Basic common seeded key for hibrid encode.
string pass; // Holds randomly generated chypher keys.
string crypt_TX; // TX Chyper data register.
string crypt_RX; // RX Chyper data register.
string Raw_data; // Raw data register.
string clean; // Decripted data register.
integer spectrum; // spectrum channels offset;
string serv_cust;
list data;
//------------------------------------------------------------------------------------------------------------------------------------
list Jsn_Tags = ["user_name", "race_name","clazz_name", "racial_name", "racials", "health", "stamina", "gender", "lvl", "clazz_type",
                 "endurance", "strength", "will", "intelligence", "perception", "finesse", "current_xp", "max_xp", "hit_chance",
                 "hit_rate", "adamant", "strength_factor", "intelligence_factor", "hit_damage", "status", "level_start_xp", "hit_absorption", "racial_type"];


//------------------------------------------------------------------------------------------------------------------------------------
//tmprep()
//{
// float xprf = ((xperience - xpstartlvl) * 100) / (maxxp - xpstartlvl);if(xprf > 100){xprf = 100;}
// llOwnerSay("Reporte de XP..." + "\nXP Actuales: " + (string)xperience + "\nXP Porcentual: " +
// (string)llRound(xprf) + " %" + "\nXP iniciales: " + (string)xpstartlvl + "\nXP Maximos: " +
// (string) maxxp + "\nXP Avanzados: " + (string)(xperience - xpstartlvl) + "\nXP Por avanzar: " +
// (string)(maxxp - xperience));
//}
//------------------------------------------------------------------------------------------------------------------------------------
HUD_Sync()
{
    string hcmsg = (string)spectrum;
    string scramb = llXorBase64(llStringToBase64(hcmsg), llStringToBase64(seeds_0));
    llWhisper(nhud_rxchn, work_psw + "," + (string) owner + "," + "Resync" + "," + scramb);
}
encrypt() // Encodes data to be sent to Relay Bridge.
{
        string scramb = llXorBase64(llStringToBase64(Raw_data), llStringToBase64(seeds_1));
        crypt_TX = llXorBase64(llStringToBase64(scramb), llStringToBase64(pass));
}
decript() // Decodes data from Relay Bridge.
{
        string scramb = llBase64ToString(llXorBase64(crypt_RX, llStringToBase64(pass)));
         clean = llBase64ToString(llXorBase64(scramb, llStringToBase64(seeds_1)));
}
//------------------------------------------------------------------------------------------------------------------------------------
no_server() {
    txt = "No server response...";
    update_text();
    llSleep(1);
    llMessageLinked(LINK_THIS, 5, "retry", "timer");
    search_server();
}
search_server() {
    llMessageLinked(LINK_THIS, 0, "booting", "ctrl");
    llListenRemove(lsn_handler); // Close Public Channel (To Avoid Wrong Bridge id Focus)
    lsn_handler = llListen(serv_rxchn, "NCS Bridge", "", "");// Open Public Channel (Unfocused to start link)
    txt = "Searching server...";
    update_text();
    crypt_TX = (serv_psw + "," + (string) owner + "," + "Ping_NCS_Server");
    serv_msg = llXorBase64(llStringToBase64(crypt_TX), llStringToBase64(seeds_0));
    llRegionSay(serv_txchn, serv_msg);//llOwnerSay("From Boot to Bridge: " + serv_msg);
    llMessageLinked(LINK_THIS, 0, "Run", "control");
    llMessageLinked(LINK_THIS, 5, "retry", "timer");
}
send_2svr() {
    serv_msg = (serv_psw + "," + (string) owner + "," + txdata);
    Raw_data = serv_msg;encrypt();
    llRegionSayTo(serv_id, serv_txchn, crypt_TX);
    //llOwnerSay(serv_msg);
}
RX_Process()
{
    //llOwnerSay("Meter > Boot Script Decoded: " + clean);
    if (llList2Key(data, 1) == owner)
        {
                string info = llList2String(data, 2);
                if (info == "hello") // Local bridge greetings RX
                {
                    serv_id = RX_id; // Store bridge ID
                    llMessageLinked(LINK_THIS, 0, (string) RX_id, "Serv_ID"); // Share bridge ID with other scripts
                    llListenRemove(lsn_handler); // Close Bridge Unfocused channel.
                    pass = llList2String(data, 3);
                    spectrum = (integer)llList2String(data, 4);
                    llMessageLinked(LINK_THIS, spectrum, "passWD", "BootSec");
                    HUD_Sync();//Sahre spectrum with hud
                    txt = "Conected...";
                    update_text();
                    lsn_handler = llListen(serv_rxchn, "NCS Bridge", serv_id, ""); // Open Focused Bridge RX channel.
                    txdata = "Send_Server_Info";
                    send_2svr();
                } // Ask for server info
                else if (info == "Ping" && boot == 0)
                {
                    txdata = "Ping_ACK";
                    send_2svr();
                } //ACK to Bridge
                else if (info == "Server_Info")
                {
                    xptics = (integer) llList2String(data, 3);
                    serv_cust = llList2String(data, 4);
                    if(serv_cust != ""){llOwnerSay(serv_cust);}
                    txt = "Acquiring data...";
                    update_text();
                    prefixurl = llList2String(data, 5);
                    string relay_id = llList2String(data, 6);
                    llMessageLinked(LINK_THIS, xptics, "XpTiC", "ctrl");
                    if (prefixurl != "")
                    {
                        llMessageLinked(LINK_THIS, 0, prefixurl, "URL_Prefix");
                    }
                    if (relay_id != "")
                    {
                        llMessageLinked(LINK_THIS, 0, relay_id, "relay_id");
                    }
                    llMessageLinked(LINK_THIS, 0, "retry", "timer");
                    online = 0;Boot();// CONTACT REMOTE SERVER !!!!
                }
            }
        else if (llList2String(data,1) == mctr_psw && llList2String(data, 2) == "BrDcTTT" && boot == 0 && err_flag == 0)
            {
                    llMessageLinked(LINK_THIS, xptics, "ticks", "Control");
            }
        else if (llList2String(data,1) == "Broadcast" && llList2String(data, 2) == "Syncro" && err_flag == 0)
            {
                    pass = llList2String(data, 3);
                    spectrum = (integer)llList2String(data, 4);
                    llMessageLinked(LINK_THIS, spectrum, "Shrd_Spc", "ctrl");
                    HUD_Sync();// Share spectrum with hud.
            }
}
//----------------------------------------------------------------------------------------------------------------------------------
process_http_status_codes()
{
    llSetTimerEvent(0);
    llMessageLinked(LINK_THIS, 0, "Off", "control");
    llMessageLinked(LINK_THIS, 0, "SBTO", "timer");
    llMessageLinked(LINK_THIS, 0, "SBWD", "timer");
    llMessageLinked(LINK_THIS, 0, "Btime_OFF", "timer");
    boot = 0;progress = 0;online = 0;err_flag = 1;
    if(http_state == 400)
        {
            secs = 300;ftext = "Not registred yet?\nAuto reboot in: ";error_txt();
            llOwnerSay("You have to create an NCS account and specify your character in order to play this game.");
            llOwnerSay("Click now the \"Go to page\" button on your screen to start your NCS account.");
            llSetText("Not registred yet?", <1, 1, 1>, 1.0);llPlaySound("21d81b50-4566-3805-5a2b-87e312eab45d", 1.0);
            url = prefixurl + "/view/profile/index.html?uuid="
             + (string)owner+ "&name=" + llEscapeURL(owname);
            llLoadURL(owner, "You have to crate an NCS account\nGo to NCS website?", url);
        }
     else if(http_state == 403)
    {
        secs = 120;
        ftext = "HTTP Error: Forbidden.\nNext attempt in: ";error_txt();
    }
    else if(http_state == 404)
    {
        secs = 120;
        ftext = "HTTP Error: Server is down...\nNext attempt in: ";error_txt();
    }
    else if(http_state == 420)
    {
        secs = 45;
        ftext = "HTTP Error: throtled!\nNext attempt in: ";error_txt();
    }
    else if(http_state == 503)
    {
        secs = 600;
        ftext = "HTTP Error: Service unavailable\nNext attempt in: ";error_txt();
    }
    else
    {
        secs = 600;
        ftext = "HTTP Error: " +  (string)http_state +"\nNext attempt in: ";error_txt();
    }
    llSetTimerEvent(1.0);
}
update_text()
{
    string btext;
    if(err_flag == 0)
    {
        btext = S_brand + "\n" + pret + Bstate + post + "\n";
        if(progress == 0)
        {
        llSetText(btext + txt, <1, 1, 1>, 1.0);}
        else if(boot > 0)
        {
            txt = "Loading... " + (string)progress + " %";
            llSetText(btext + txt, <1, 1, 1>, 1.0);
            if(tsw == 0){pret += "<";post += ">";if(llStringLength(post) > 3){tsw = 1;}}
            if(tsw == 1){pret = llDeleteSubString(pret,0,0);post = llDeleteSubString(post,0,0);
            if(llStringLength(post) == 0){tsw = 0;}}
        }
    }
}
error_txt()
{
    llSetText(ftext + (string)secs + " secs.", <1, 1, 1>, 1.0);
    secs -= 1;if(secs <= 0){reboot();}
}
reboot()
{
    err_flag = 0;
    llMessageLinked(LINK_THIS, 0, "ini", "NCS_MAIN_SCRP");
}
retrycall()
{
   retry += 1;
   if(retry >= 3)
    {
    retry = 0;
    noserver();
    }
    contact_remote_server();
}
noserver()
{
    if(boot == 0)
        {
             Bstate = " Opps! ";
            llSetTimerEvent(0);txt = "No server response";
        }
        else
        {
            Bstate = " Please wait ";
            txt = "Connection lost";progress = 0;//llMessageLinked(LINK_THIS, progress, txt, "NCS_MAIN_DSP");
        }
      //  llMessageLinked(LINK_THIS, progress, txt, "NCS_MAIN_DSP");
       update_text();llSleep(1);ini();
}
ini()
{
    llSetText("", ZERO_VECTOR, 0.0);
    llMessageLinked(LINK_THIS, 0, "Off", "control");
    //boot = 1;
    progress = 0;
    owner = llGetOwner();
    owname = llKey2Name(owner);
    llSetTimerEvent(0);
    llMessageLinked(LINK_THIS, 0, "SBTO", "timer"); // Stop boot timeout timer.
  //  llMessageLinked(LINK_THIS, 0, "Run", "control"); // Start timer script.
    err_flag = 0;progress = 0;retry = 0;online = 0;boot = 0;
    tsw = 0;pret = "";post = "";llSleep(1);
    //----------------------------------------------INS--------------------------
    txt = "Starting...";
    update_text();
    llSleep(1);
    search_server();
}
Boot()
{
     if(boot == 0)
            {
                boot = 1;Bstate = " Loggin user ";
                start_boot_watchdog();// Start boot watchdog
                llMessageLinked(LINK_THIS, 0, "SBTO", "timer"); // Stop boot timeout timer.
               // llMessageLinked(LINK_THIS, 0, "Run", "control"); // Start timer script.
                    if(online == 1)
                    {
                        online = 0;
                        txt = "Rebooting...";
                    }
                    else
                    {
                        txt = "initiating...";
                    }
                //llMessageLinked(LINK_THIS, progress, txt, "NCS_MAIN_DSP"); // Update Text
                update_text();
                llSleep(2);
                reset_request_timeout(); // Start and reset boot timeout timer.
                start_boot_watchdog();
                contact_remote_server();
            }
}
start_boot_watchdog()
{
    llMessageLinked(LINK_THIS, 30, "SBWD", "timer"); // Set and start boot watchdog Timer.
}
reset_request_timeout()
{
    llMessageLinked(LINK_THIS, 6, "SBTO", "timer"); // Set and reset boot Time Out Timer.
}
contact_remote_server()
{
    string url;
    if(err_flag == 0)
    {
    if(boot == 1)
        {
            url = prefixurl + "/relay/api/user/" + (string)owner;
        }
    else if(boot == 2)
        {
            url = prefixurl + "/relay/api/user/" + (string)owner + "/skills/offensive";
        }
    else if(boot == 3)
        {
            url = prefixurl + "/relay/api/user/" + (string)owner + "/skills/support";
        }
     else if(boot == 4)
        {
            url = prefixurl + "/relay/api/user/" + (string)owner + "/skills/healing";
        }
        http_request_id = llHTTPRequest(url, [], "");//llSay(0, url);
        reset_request_timeout();
    }
    else{Bstate = " Registration needed ";}
}

checkDuplicates() {
    list AttachedNames;
    list AttachedUUIDs = llGetAttachedList(llGetOwner());
    integer i;
    
    while (i < llGetListLength(AttachedUUIDs) ) {
        list temp = llGetObjectDetails(llList2Key(AttachedUUIDs,i),[OBJECT_NAME]);
        string name = llList2String(temp, 0);
        
        if (name == "NCS Meter v1.0.1")
            AttachedNames += [name];
        ++i;
    }
    
    if (llGetListLength(AttachedNames) > 1)
        llDie();
}

default
{
    attach(key id) {
        checkDuplicates();
    }

    state_entry()
    {
        llSleep(2); // To give time for all prims and scripts to change ownership on the first use.
        llMessageLinked(LINK_THIS, 0, "Reset_By_GM", "ctrl"); // To init Meter properly.
        ini();
    }
    
    http_response(key request_id, integer statusrq, list metadata, string body)
    {
        if (statusrq != 200)//request_id != http_request_id
        {
            err_flag = 1;http_state = statusrq;
            process_http_status_codes();
        }
        else if(req_flag == 1){req_flag = 0;llMessageLinked(LINK_THIS, 0, body, "RESPONSE_SECURITY_LEVEL_UP");}
        else if(req_flag == 2){req_flag = 0;llMessageLinked(LINK_THIS, 0, body, "RESPONSE_SECURITY_PROFILE");}
        else if (request_id == http_request_id)
        {
        if(statusrq == 200 &&  err_flag == 0)
            {
                integer skip;
                string Data;
                list Serv_Data = [];
                reset_request_timeout(); // Start and reset boot timeout timer.
                retry = 0;
                if(boot == 1)
                    {
                        progress = 0;Bstate = " Logged in ";update_text();llSleep(1);
                        txt = "Starting";Bstate = " Negotiating protocols ";
                        update_text();//llMessageLinked(LINK_THIS, progress, txt, "NCS_MAIN_DSP"); // Update Text
                        llSleep(1);Bstate = " Aquiring data ";
                        update_text();//llMessageLinked(LINK_THIS, progress, txt, "NCS_MAIN_DSP"); // Update Text
    //---------------------------------------------------------
              //  llOwnerSay(body);
                        string Jsn_Content;
                        string Jsn_Spec;
                        integer lislen = llGetListLength(Jsn_Tags);
                        integer i;
                        //txt = "Progress: " + (string)progress + " %";
                        for(i = 0; i < lislen; i++)
                        {
                            Jsn_Spec = llList2String(Jsn_Tags, i);
                            Jsn_Content = llJsonGetValue(body, [Jsn_Spec]);
                            Serv_Data += Jsn_Content;
                            progress += 1;update_text();
                        }
                            //llMessageLinked(LINK_THIS, progress, txt, "NCS_MAIN_DSP"); // Update Text
                        Data = llList2CSV(Serv_Data);Bstate = " Processing. ";
                        llMessageLinked(LINK_THIS, 0, Data, "NCS_MAIN_CHAR");//llSay(0, body); // Character data to main script
                        boot = 2;skip = 1;llSetTimerEvent(0.08);
                        }
                else
                    {
                        Data = llList2CSV(llJson2List(llJsonGetValue(body, [])));
                        Serv_Data = llCSV2List(Data);
                        integer lislen = llGetListLength(Serv_Data);
                        if(lislen > 132){lislen = 132;}
                        integer i;
                        integer j = 0;
                        integer k = 0;
                        for(i = 1; i < lislen; i++)
                        {
                            Serv_Data = llListInsertList(Serv_Data, [0], i + j);j += 1;
                            i += 12;progress += 1;update_text();//llMessageLinked(LINK_THIS, progress, txt, "NCS_MAIN_DSP"); // Update Text
                        }
                    lislen = llGetListLength(Serv_Data);Bstate = " Validating. ";
                    if(lislen > 143){Serv_Data = llList2List(Serv_Data, 0, 153);}
                    Data = llList2CSV(Serv_Data);
                    string sktransf;
                    if(boot == 2 && skip == 0){sktransf = "Offensive_0";Bstate = " Processing: Block 3 ";}
                     else if(boot == 3){sktransf = "Support";Bstate = " Processing: Block 4 ";}
                    else if(boot == 4){sktransf = "Healing";Bstate = " Processing: Block 5 ";}
                    llMessageLinked(LINK_THIS, 0, Data, sktransf);//llSay(0, Data);
                    }
                start_boot_watchdog();skip = 0;
            }
        }
    }
    //--------------------------------------------------------------------------------------------------------------------
    listen(integer chnl, string name, key id, string mesg)
    {
       // llOwnerSay("Boot Script Raw RX: " + mesg);
        RX_id = id;
        crypt_RX = mesg;decript();
        data = llCSV2List(clean);
        string passw = llList2String(data, 0); // Get local bridge relay data...
        if(passw == metr_psw)
        {
            RX_Process();
        }
        else
        {
            clean = llBase64ToString(llXorBase64(crypt_RX, llStringToBase64(seeds_0)));
            data = llCSV2List(clean);
            string passw = llList2String(data, 0);
            if(passw == metr_psw)
            {
                RX_Process();
            }
        }
    }
    //----------------------------------------------------------------------------------------------------------------------
     link_message(integer sender, integer num, string lmsg, key id)
    {
        if(id == "NCS-MBoot")
        {
            if(lmsg == "CBTO"){retrycall();}
            else if(lmsg == "CSBWD"){noserver();}
        }
        else if(id == "NCS_BOOT")
        {
            //if(lmsg == "START_B!"){online = 0;ini();Boot();}
            if(lmsg == "SkIlLzOk!"){boot = num;}
        }
        else if(id == "Sec_rq" && lmsg == "Sec_rq")
        {
            req_flag = 1;
        }
        else if(id == "Sec_rq2" && lmsg == "Sec_rq2")
        {
            req_flag = 2;
        }
         else if(id == "URL_Prefix")
        {
            prefixurl = lmsg;
        }
        else if(id == "MAIN_COM")
        {
            if(lmsg == "Comb_St"){txdata = "Comb_St";send_2svr();}
            else if(lmsg == "No_Comb"){txdata = "No_Comb";send_2svr();}
            else if(lmsg == "NCS_Detach"){txdata = "NCS_Detach";send_2svr();}
            else if(lmsg == "NCS_Boot"){txdata = "NCS_Boot";send_2svr();}
            else if(lmsg == "LOG_IN_BRIDGE"){ini();}
        }
        else if (id == "ctrl")
        {
            if (lmsg == "retry")
             {
                no_server();
            }
        }
        else if (id == "controls")
        {
            if(lmsg == "leveledup")
            {
                llSetTimerEvent(0);boot = -1;
                string text = S_brand + "\n!LEVELED UP!\nGo to page and restart the\n NCS Meter when you done.";
                llSetText(text, <1, 1, 1>, 1.0);
            }
        }
        else if (id == "Snd_To_Bridge")
        {
            txdata = lmsg;
             send_2svr();
        }
    }
    timer()
    {
        if(err_flag == 0)
        {
        if(boot >= 5 && progress >= 100){llSetTimerEvent(0);llMessageLinked(LINK_THIS, 0, "SBTO", "timer");
        llMessageLinked(LINK_THIS, 0, "SBWD", "timer");online = 1;progress = 0;boot = 0;Bstate = "";
        llMessageLinked(LINK_THIS, 0, "boot_0", "NCS_MAIN_T");}//llMessageLinked(LINK_THIS, 0, "Btime_OFF", "timer");
        else if(boot == 2 && progress < 50){progress += 1;if(progress >= 50){progress = 50;contact_remote_server();}}
        else if(boot == 3 && progress < 66){progress += 1;if(progress >= 66){progress = 66;contact_remote_server();}}
        else if(boot == 4 && progress < 86){progress += 1;if(progress >= 86){progress = 86;contact_remote_server();}}
        else if(boot >= 5 && progress < 100){progress += 1;if(progress >= 100){progress = 100;}}
        if(online == 0){update_text();}
        }
        else if(err_flag == 1){error_txt();}
    }
    
    changed(integer mask) {
        if (mask & CHANGED_OWNER) {
            llResetScript();
            ini();
        }
        
        if (mask & CHANGED_INVENTORY && llGetObjectDesc() == "Release") {
            llDie();
        }
    }
}