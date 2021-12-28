integer lhandler;
integer lh;
integer rxchan = -1999996429;
integer txchan = -1999999429;
integer stat_rxchn = -627782887; // Dealer API channel.
integer spectrum;
string ASCII = "9ew0E5mTdx36pqszgDLcvtIbOrPBY1X7WHfikSUaoJR24KNGC8MyuAnVlQhjF"; // Scrambled char set, to be used randomly by chypher keys generator,
string seeds_0 = "LfqZg9lqDejaDo22DMO0tnQeWK4lus9ztpkFHUwT"; // Basic common seeded key for data exchange.
string seeds_1 = "ZPKlHpA3LnT1zZgnRj9q6ootfBx8kvIU2PKtEA6g"; // Basic common seeded key for hibrid encode.
string pass; // Holds randomly generated chypher keys.
string crypt_TX; // TX Chyper data register.
string crypt_RX; // RX Chyper data register.
string clean; // Decripted data register.
string Chy_data; // Data to be Chyper register.
string Raw_data; // Raw data register.
list data;
integer xptics = 8;
string servmsg = "NCS initial testing... thanks for your support. Your opinons are welcome!";
string prefixurl;
string apipass;
string txpass;
string rxpass;
string txdata;
string owname;
string race;
string class;
key owner;
key client;

randomize_spectrum() // Spectrum coms offset generator.
{
        integer enumber = llRound(llFrand(876824));if(enumber < 50000){enumber += 100000;}
        integer rnumber = llRound(llFrand(100000)) + 739568;
        spectrum = (rnumber ^ enumber);
}
gen_key() // Chypher key generator... Renews Chyppher keys for coms.
{
        string j;
        integer k;
        integer i;
        pass = "";
        for(i = 0; i < 20; i++)
            {
                k = llRound(llFrand(60));
                pass += llGetSubString(ASCII, k, k);
            }
    Raw_data = txpass + "," + "Broadcast" + "," + "Syncro" + "," + pass + "," + (string)spectrum;
    Private_Broadcast_Data();
}
encript() // Encodes public data to be sent to clients.
{
        string scramb = llXorBase64(llStringToBase64(Raw_data), llStringToBase64(seeds_1));
        crypt_TX = llXorBase64(llStringToBase64(scramb), llStringToBase64(pass));
}
decript() // Decodes public data from clients.
{
        Chy_data = llBase64ToString(llXorBase64(crypt_RX, llStringToBase64(pass)));
         clean = llBase64ToString(llXorBase64(Chy_data, llStringToBase64(seeds_1)));
}
ini()
{
    rxchan = -1999996429;
    txchan = -1999999429;
    owner = llGetOwner();
    owname = llKey2Name(llGetOwner());
    txpass = "NCSv1.0Ogaleicrum9429¡";
    rxpass = "NCSv1.0Murcielago9429!";
    apipass = "NCSv1.0onmZ7tK9429!";
    randomize_spectrum();// generate spectrum offset.
    gen_key();// generate public key & update security keys and spectrum offset to clients.
    llListenRemove(lhandler);llListenRemove(lh);
    lhandler = llListen(rxchan, "NCS Meter v1.0.0", "", "");
    lh = llListen(stat_rxchn, "", "", "");
}
send_info()
{
    txdata = (string)client + "," + "Server_Info" + "," + (string)xptics + "," + servmsg + "," + prefixurl + "," + getRelayId();
    send_response();
}
send_response() // Focused response.
{
    Raw_data = txpass + "," + txdata;
    encript();
    llRegionSayTo(client,txchan,crypt_TX);//llOwnerSay(crypt_TX);
    llMessageLinked(LINK_THIS, 0, "TX", "Master");// This is for Relay Bridge Glow FX only.
}
Private_Broadcast_Data() // Unfocused response (For All clients.)
{
    crypt_TX = llXorBase64(llStringToBase64(Raw_data), llStringToBase64(seeds_0));// Coded Private.
    llRegionSay(txchan,crypt_TX);//llOwnerSay("Bridge Coded TX: " + crypt_TX);
    llMessageLinked(LINK_THIS, 0, "TX", "Master");// This is for Relay Bridge Glow FX only.
}

string getRelayId() {
    string id = llGetObjectDesc();

    if (id == "???")
        return JSON_NULL;
    else
        return id;
}
RX_Process()
{
        list data = llCSV2List(clean);
        string passw = llList2String(data, 0);
        integer datalen = llGetListLength(data);
        client = llList2Key(data, 1);
            string request = llList2String(data, 2);

            if(datalen >= 5){
                race = llList2String(data, 3);
                class = llList2String(data, 4);}
            if(request == "Ping_NCS_Server")
            {
                Raw_data = txpass + "," + (string)client + "," + "hello" + "," + pass + "," + (string)spectrum;
                Private_Broadcast_Data();
            }
            else if(request == "Send_Server_Info")
            {
                txdata = (string)client + "," + "Server_Info" + "," + (string)xptics + "," + servmsg + "," + prefixurl + "," + getRelayId();
                send_response(); // Focused response.  (Coded Public.)
            }
            else if(request == "Send_Boot_Info")
            {
                llMessageLinked(LINK_THIS, 0, "Send_Client_Data", client);
            }
            else if(request == "Ping_ACK"){llMessageLinked(LINK_THIS, 1, "P_ACK", client);}
            else if(request == "NCS_Boot"){llMessageLinked(LINK_THIS, 1, "ADD", client);}
            else if(request == "NCS_Detach"){llMessageLinked(LINK_THIS, 1, "REMOVE", client);}
            else if(request == "NLP"){llMessageLinked(LINK_THIS, 1, "NLP", client);}
            else if(request == "No_Comb" || request == "Locked"){llMessageLinked(LINK_THIS, 1, "REMOVE", client);}
            else if(request == "Comb_St" || request == "Unlocked"){llMessageLinked(LINK_THIS, 1, "ADD", client);}
            else if(request == "Save_Title")
            {
                string title = llList2String(data, 3);
                string query = "Save_Title_Data" + "," + title;
                llMessageLinked(LINK_THIS, 0, query, client);
            }
            else if(request == "Send_This_Skills")
            {
                list lquery = llList2List(data, 3, datalen);
                string query = "Send_Requested_Skills" + "," + llList2CSV(lquery);
                llMessageLinked(LINK_THIS, 7, query, client);
               // llOwnerSay(query);
            }
            else if(request == "Send_Char_Info")
            {
                string query = "Send_Char_Data" + "," + race + "," + class;
                llMessageLinked(LINK_THIS, 0, query, client);
            }
             else if(request == "Send_Skill0_Info")
            {
                string query = "Send_Skill0_Data" + "," + race + "," + class;
                llMessageLinked(LINK_THIS, 0, query, client);
            }
             else if(request == "Send_Skill1_Info")
            {
                string query = "Send_Skill1_Data" + "," + race + "," + class;
                llMessageLinked(LINK_THIS, 0, query, client);
            }
             else if(request == "Send_Skill2_Info")
            {
                string query = "Send_Skill2_Data" + "," + race + "," + class;
                llMessageLinked(LINK_THIS, 0, query, client);
            }
}

default
{
    state_entry()
    {
        //llSetObjectDesc("???");
        owner = llGetOwner();
    }
attach(key attached)
    {
        if(attached != NULL_KEY)
        llRequestPermissions(owner, PERMISSION_ATTACH);
        llSay(0, "NCS BRIDGE CAN NOT BE WORN.");
        llDetachFromAvatar();
    }
    listen(integer chan, string name, key id, string mesg)
    {
        //llOwnerSay("Raw: " + mesg);
        if(chan == rxchan)
        {
            crypt_RX = mesg;decript();//llOwnerSay("Private clean: " + clean);
            list data = llCSV2List(clean);
            string passw = llList2String(data, 0);
            if(passw == rxpass)
            {
                RX_Process();
            }
            else
            {
                clean = llBase64ToString(llXorBase64(crypt_RX, llStringToBase64(seeds_0)));
                list data = llCSV2List(clean);
                string passw = llList2String(data, 0);//llOwnerSay("Chyp private: " + clean);
                if(passw == rxpass)
                {
                 RX_Process();
                }
            }
        }
         if(chan == stat_rxchn)
        {
            string unscramb = llBase64ToString(llXorBase64(mesg, llStringToBase64(seeds_0)));// Coded Private.
            list data = llCSV2List(unscramb);
            string passw = llList2String(data, 0);
            if(passw == apipass)
            {
                client = llList2Key(data, 1);
                string request = llList2String(data, 2);
                if(request == "Poll_Spec_NCS_Server")
                {
                    Raw_data = apipass + "," + (string)client + "," + (string)spectrum;
                    crypt_TX = llXorBase64(llStringToBase64(Raw_data), llStringToBase64(seeds_0));// Coded Private.
                    llRegionSayTo(client,txchan,crypt_TX);
                    llMessageLinked(LINK_THIS, 0, "TX", "Master");// This is for Relay Bridge Glow FX only.
                }
            }
        }
        llMessageLinked(LINK_THIS, 0, "RX", "Master");
    }
    link_message(integer sender, integer num, string str, key id)
        {
          //  llOwnerSay("Bridge Main Script Linked RX: " + "<< Num >> " + (string)num + " << Msg >> " + str + " << ID >> " + (string)id);
            if(num == 1)
            {
                if(str == "Req_Clien_Data" && id == (string)client)
                {
                list data = llCSV2List(str);
                integer datalistlen = llGetListLength(data);
                string values;
                txdata = (string)client + ",";
                integer i;
        for (i = 0; i < datalistlen; i++)
                {
                values =llList2String(data, i);
                txdata += values + ",";
                }
                //llOwnerSay(txdata);
                send_response();
                }
            }
            else if(num == 134 && id == "Shred_URL")
            {
                prefixurl = str;
            } else if (num == 134 && id == "RESET") {
                llResetScript();
                return;
            }
            else if(num == 134 && id == "Shred_SPECT")
            {
                randomize_spectrum();
                gen_key();
            }
            else if (num == 24021955 && id == "REGISTER_SUCCESS") {
                ini();
            }
            else if (num == 89898996 && id == "Brdcst")
            {
                Raw_data = str;
                string scramb = llXorBase64(llStringToBase64(Raw_data), llStringToBase64(seeds_1));
                crypt_TX = llXorBase64(llStringToBase64(scramb), llStringToBase64(pass));
                llRegionSay(txchan,crypt_TX);//llOwnerSay("Cypher Data: " + crypt_TX);
                llMessageLinked(LINK_THIS, 0, "TX", "Master");// This is for Relay Bridge Glow FX only.
            }
        }
        changed(integer mask)
    {
        if(mask & CHANGED_OWNER){llResetScript();}
    }
}