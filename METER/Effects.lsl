integer mstr_rxchn;
integer sex;
integer status;
integer listenHandler;
string owname;
string work_psw;
integer nhud_rxchn;
integer reflect;

initialize(string data) {
    if (listenHandler != 0)
        llListenRemove(listenHandler);

    list listData = llCSV2List(data);
    mstr_rxchn = (integer) llList2String(listData, 0);
    sex = (integer) llList2String(listData, 1);
    work_psw = llList2String(listData, 2);
    nhud_rxchn = (integer) llList2String(listData, 3);
    owname = llKey2Name(llGetOwner());
    status = 1;
    listenHandler = llListen(mstr_rxchn, "", "", "");
}

handleSkillsMessage(string lmsg) {
    list skdata = llCSV2List(lmsg);
    string fsk_m = llList2String(skdata, 0);    
    integer hp = (integer) llList2String(skdata, 8);
    integer stp = (integer) llList2String(skdata, 6);
    integer racial = (integer) llList2String(skdata, 5);
    integer stefect = (integer) llList2String(skdata, 10);
    integer qty = (integer) llList2String(skdata, 11);

    if (fsk_m == "Skill_Self") {
        integer duration = (integer) llList2String(skdata, 12);
        string skl = (string) llList2String(skdata, 1);;
        integer meth = (integer) llList2String(skdata, 3);
        string midtxt = "him";
        string hmsg;

        // Apply skill damage
        llMessageLinked(LINK_THIS, hp, "health", "effect");
        llMessageLinked(LINK_THIS, stp, "stam", "effect");
        llMessageLinked(LINK_THIS, racial, "racial", "effect");

        if (sex == 1) {
            midtxt = "her";
        }

        if (hp > 0 && stp < 0) { // particles
            llMessageLinked(LINK_THIS, 0, "faid", "controls");
        }

        if (stefect == 9 && qty && meth == 3) {
            llMessageLinked(LINK_THIS, qty, "armor0", "effect");
            llMessageLinked(LINK_THIS, llRound((qty / 1.25)), "extraWill", "effect");
            llMessageLinked(LINK_THIS, duration, "armor0TO", "timer");
            llMessageLinked(LINK_THIS, 0, "armr", "controls");
            hmsg = "Hud_Armor";
            llSay(0, owname + " a sudden rush of anger makes " + midtxt + " dangerously tough!");
        } else if (stefect == 10 && meth == 3) {
            llMessageLinked(LINK_THIS, qty, "buff0", "effect");
            llMessageLinked(LINK_THIS, duration, "buff0TO", "timer");
            llMessageLinked(LINK_THIS, 0, "bffd", "controls");
            hmsg = "Hud_Buff";
        } else if (stefect == 7) {
            llMessageLinked(LINK_THIS, qty, "hot0", "effect");
            llMessageLinked(LINK_THIS, duration, "hot0TO", "timer");
            llMessageLinked(LINK_THIS, 0, "faid", "controls");
            llSay(0, owname + " starts regenerating!");
            hmsg = "Hud_Hot";
        } else if (stefect == 23) { // Reflect
            reflect = qty;
            llSay(0, owname + " starts reflecting incoming damage");
            llMessageLinked(LINK_THIS, duration, "reflectTO", "timer");
        } else if (stefect == 29) { // Effect 29 is stamina regen
            llMessageLinked(LINK_THIS, qty, "sot", "effect");
            llMessageLinked(LINK_THIS, duration, "sotTO", "timer");
            llMessageLinked(LINK_THIS, 0, "faid", "controls");
            hmsg = "Hud_Hot";
        } else if (stefect == 17) {
            effectTempStam(duration, qty);
            llSay(0, owname + " your stamina has risen " + (string) qty + " points for a while!");
        } else if (stefect == 18) {
            llMessageLinked(LINK_THIS, qty, "tmplife", "effect");
            llMessageLinked(LINK_THIS, duration, "tmplifeTO", "timer");
            llSay(0, owname + " your health has risen " + (string) qty + " points for a while!");
        } else if (stefect == 21) {
            llMessageLinked(LINK_THIS, qty, "hot1", "effect");
            llMessageLinked(LINK_THIS, duration, "hot1TO", "timer");
            llMessageLinked(LINK_THIS, 0, "faid", "controls");
            hmsg = "Hud_Hot";
        } else if (stefect == 22) {
            llMessageLinked(LINK_THIS, qty, "stam", "effect");
        } else if (stefect == 13) { // Revive
            list data = ["revive", hp, stp];
            llMessageLinked(LINK_THIS, 0, llList2CSV(data), "effect");
            hp = 0;
        } else if (stefect == 28) {
            llMessageLinked(LINK_THIS, 0, "unweak", "effect");
        } else if (stefect == 11 && meth == 3) {
            //          qty = (integer) llList2String(skdata, 12);
            //          inmune = 1;
            //          llSay(0, owname + " can't be harmed momently!");
            //          llMessageLinked(LINK_THIS, qty, "guardTO", "timer");
        } else if (stefect == 30 && meth == 3) {
            llMessageLinked(LINK_THIS, qty, "armor0", "effect");
            llMessageLinked(LINK_THIS, (qty / 2), "extraWill", "effect");
            llMessageLinked(LINK_THIS, (qty / 2), "extraIntel", "effect");
            llMessageLinked(LINK_THIS, duration, "armor0TO", "timer");
        } else if (stefect == 12) {
            effectBuff1(duration, qty);
            effectArmor1(duration, qty);
            effectTempLife(duration, qty * 4);
            effectTempStam(duration, llRound(qty * 3));
            llMessageLinked(LINK_THIS, llRound(qty / 2), "extraIntel", "effect");
            llMessageLinked(LINK_THIS, llRound(qty / 2), "extraWill", "effect");
        }

        if (hmsg != "") {
            string hudtxd = work_psw + "," + (string) llGetOwner() + "," + hmsg;
            llWhisper(nhud_rxchn, hudtxd);
        }
    } else if (fsk_m == "Skill_Pay") {    
        // Apply skill damage
        llMessageLinked(LINK_THIS, hp, "health", "effect");
        llMessageLinked(LINK_THIS, stp, "stam", "effect");
        llMessageLinked(LINK_THIS, racial, "racial", "effect");
        
        if (stefect == 4) { // Weak
            llMessageLinked(LINK_THIS, qty, "stam", "effect");
        } 
    }
}

handleControlMessages(string lmsg, integer num) {
    if (lmsg == "Pow_on" || lmsg == "Unlock_By_GM")
        status = 1;
    else if (lmsg == "Pow_off" || lmsg == "Lock_By_GM") {
        status = 0;
        //llListenRemove(listenHandler);
    }

    if (lmsg == "live") {
        llMessageLinked(LINK_THIS, 0, "live", "effect");
    } else if (lmsg == "heal_1") {
        llMessageLinked(LINK_THIS, num, "health", "effect");
        llMessageLinked(LINK_THIS, num, "stam", "effect");
    } else if (lmsg == "heal") {
        llMessageLinked(LINK_THIS, num, "stam", "effect");
    } else if (lmsg == "armor0TO") {
        llMessageLinked(LINK_THIS, 0, "armor0", "effect");
        llMessageLinked(LINK_THIS, 0, "extraWill", "effect");
        llMessageLinked(LINK_THIS, 0, "extraIntel", "effect");
    } else if (lmsg == "armor1TO") {
        llMessageLinked(LINK_THIS, 0, "armor1", "effect");
    } else if (lmsg == "guardTO") {
//        inmune = 0;
//        pmsg = " immunity shield depleted now may take damage again.";
    } else if (lmsg == "tmpstamTO") {
        llMessageLinked(LINK_THIS, 0, "tmpstam", "effect");
    } else if (lmsg == "tmplifeTO") {
        llMessageLinked(LINK_THIS, 0, "tmplife", "effect");
    } else if (lmsg == "hot0TO") {
        llMessageLinked(LINK_THIS, 0, "hot0", "effect");
    } else if (lmsg == "hot1TO") {
        llMessageLinked(LINK_THIS, 0, "hot1", "effect");
    } else if (lmsg == "sotTO") {
        llMessageLinked(LINK_THIS, 0, "sot", "effect");
    } else if (lmsg == "reflectTO") {
      reflect = 0;
      llSay(0, owname + " stops reflecting incoming damage");
    } else if (lmsg == "dotTO") {
        llMessageLinked(LINK_THIS, 0, "dot", "effect");
    } else if (lmsg == "poisTO") {
        llMessageLinked(LINK_THIS, 0, "poison", "effect");
    } else if (lmsg == "buff1TO") {
        llMessageLinked(LINK_THIS, 0, "buff1", "effect");
    } else if (lmsg == "buff0TO") {
        llMessageLinked(LINK_THIS, 0, "buff0", "effect");
    } else if (lmsg == "tempStatTO") {
        llMessageLinked(LINK_THIS, 0, "tempStat", "effect");
    }
}

handleHudSetup(list data, string msg) {
    if (msg == "Poll_Meter") { // Status request from HUD
        llMessageLinked(LINK_THIS, 0, "Poll_Meter", "effect");
    } //else if (msg == "Poll_Status") {
      //  llMessageLinked(LINK_THIS, 0, "Poll_Rep", "Info"); // commented (was used by Dealer API)
      //  llMessageLinked(LINK_THIS, 0, "Poll_Rep", "effect"); // commented (was used by Dealer API)
   // } // Status request from Dealer API
    else if (msg == "Set_Key" || msg == "HUD_Key") {
        string funct = msg + "," + llList2String(data, 3);
        llMessageLinked(LINK_THIS, 1, funct, "Skills");
    } else if (msg == "Hud_Offe" || msg == "Hud_Def") {
        string funct = msg + "," + llList2String(data, 3) + "," + llList2String(data, 4);
        llMessageLinked(LINK_THIS, 1, funct, "Skills");
    } else if (llList2String(data, 3) == "F2") {
        llMessageLinked(LINK_THIS, 0, "Menu", "Skills");
    }
}

handleDamageEffects(string lmsg) {
    list data = llCSV2List(lmsg);

    if (reflect > 0) { // Reflect damage
        integer reflectedDamage = (reflect * ((integer) llList2String(data, 1))) / 100; // reflect % of received damage
        list reflection = [work_psw, llList2String(data, 2), "DAMAGE", llGetOwner(), reflectedDamage];
        string txdata = llList2CSV(reflection);
        llShout(mstr_rxchn, txdata);
    }
}

effectBuff1(integer duration, integer amount) {
    llMessageLinked(LINK_THIS, amount, "buff1", "effect");
    llMessageLinked(LINK_THIS, amount, "extraPerception", "effect");
    llMessageLinked(LINK_THIS, duration, "buff1TO", "timer");
    llMessageLinked(LINK_THIS, 0, "bffd", "controls");
}

effectArmor1(integer duration, integer amount) {
    llMessageLinked(LINK_THIS, amount, "armor1", "effect");
    llMessageLinked(LINK_THIS, duration, "armor1TO", "timer");
    llMessageLinked(LINK_THIS, 0, "armr", "controls");
}

effectTempLife(integer duration, integer amount) {
    llMessageLinked(LINK_THIS, amount, "tmplife", "effect");
    llMessageLinked(LINK_THIS, duration, "tmplifeTO", "timer");
}

effectTempStam(integer duration, integer amount) {
    llMessageLinked(LINK_THIS, amount, "tmpstam", "effect");
    llMessageLinked(LINK_THIS, duration, "tmpstamTO", "timer");
}

default {

    listen(integer chnl, string name, key id, string mesg) {
        if (chnl == mstr_rxchn) {
            list data = llCSV2List(mesg);

            if (llList2String(data, 0) == work_psw) { // Mele in and Mele out RX ACK
                key agent = (key) llList2String(data, 1);
                string msg = llList2String(data, 2);

                if (agent == llGetOwner()) {
                    if (msg == "DAMAGE") {
                        integer damage = (integer) llList2String(data, 4);
                        llMessageLinked(LINK_THIS, 0, llList2CSV(["receive_damage", llList2String(data, 3), damage]), "effect");
                    } else
                        handleHudSetup(data, msg);
                }

                if (status == 1) { // Data collect
                    integer rintelli = (integer) llList2String(data, 3);
                    key victim = (key) llList2String(data, 4);

                    if (victim == llGetOwner() || msg == "ASkill") {
                        if (msg == "RSkill" || msg == "ASkill") // Skill RX
                        {
                            integer H_flag = 0;
                            string hmsg;
                            string skclass = (string) llList2String(data, 5);
                            integer skmethod = llList2Integer(data, 6);

                            string skname = (string) llList2String(data, 9);
                            integer stamin = (integer) llList2String(data, 13);
                            integer lifein = (integer) llList2String(data, 15);
                            integer efectin = (integer) llList2String(data, 16);
                            integer ammount = (integer) llList2String(data, 17);
                            integer duration = (integer) llList2String(data, 18);

                             if (skmethod == 4) {
                                 if ((skclass == "Healing" || skclass == "Support") && !llSameGroup(agent)) {return;} // If healing/support area skill received is from different group, ignore.
                                if (skclass == "Offense" && llSameGroup(agent)) {return;} // If offensive area skill received is from same group, ignore.
                            }

                            //-------------------------------------------------------
                            if (efectin == 13) {
                                llMessageLinked(LINK_THIS, 0, llList2CSV(["revive2", lifein]), "effect");
                                lifein = 0;
                                efectin = 0;
                            }

                            if (lifein > 0) {
                                H_flag = 1;
                                llMessageLinked(LINK_THIS, lifein, "health", "effect");
                            }

                            if (stamin > 0) {
                                H_flag = 1;
                                llMessageLinked(LINK_THIS, stamin, "stam", "effect");
                            }

                            if (efectin == 7) {
                                llMessageLinked(LINK_THIS, ammount, "hot1", "effect");
                                llMessageLinked(LINK_THIS, duration, "hot1TO", "timer");
                                llMessageLinked(LINK_THIS, 0, "faid", "controls");
                                efectin = 0;
                            } else if (efectin == 9) {
                                effectArmor1(duration, ammount);
                                efectin = 0;
                                hmsg = "Hud_Armor";
                            } else if (efectin == 20) {
                                llMessageLinked(LINK_THIS, 0, "uncursed", "effect");
                                efectin = 0;
                            } else if (efectin == 28) {
                                llMessageLinked(LINK_THIS, 0, "unweak", "effect");
                                efectin = 0;
                            } else if (efectin == 10) {
                                effectBuff1(duration, ammount);
                                hmsg = "Hud_Buff";
                                efectin = 0;
                            } else if (efectin == 11) {
                                //                                inmune = 1;
                                //                                llSay(0, owname + " can't be harm by now!");
                                //                                llMessageLinked(LINK_THIS, duration, "guardTO", "timer");
                            }

                            if (lifein < 0 || stamin < 0 || efectin != 0)
                                llMessageLinked(LINK_THIS, 0, llList2CSV(["skill_hit", lifein, stamin, agent, rintelli, skclass]), "effect");

                            if (efectin != 0) {
                                llMessageLinked(LINK_THIS, 0, llList2CSV(["skill_effect", efectin, duration, agent, rintelli, ammount, skclass]), "effect");
                            }

                            if (hmsg != "") {
                                string hudtxd = work_psw + "," + (string) llGetOwner() + "," + hmsg;
                                llWhisper(nhud_rxchn, hudtxd);
                            }
                        } //---------------------------------------------------------------------------------------------------------------------

                        integer melein = (integer) llList2String(data, 5);
                        integer stamin = (integer) llList2String(data, 6);
                        integer efectin = (integer) llList2String(data, 7);
                        integer duration = (integer) llList2String(data, 8);
                        float attackerPerception = (float) llList2String(data, 9);

                        //---------------------------------------------------------------------------------------------------------------------

                        if (msg == "RMele") { // Mele RX
                            llMessageLinked(LINK_THIS, 0, llList2CSV(["mele_in", melein, agent, attackerPerception]), "effect");
                        }
                        //---------------------------------------------------------------------------------------------------------------------
                        else if (msg == "HHeal") // Healer devices RX
                        {
                            llMessageLinked(LINK_THIS, 0, "live", "effect");
                            llMessageLinked(LINK_THIS, stamin, "stam", "effect");
                            llMessageLinked(LINK_THIS, melein, "health", "effect");
                            llMessageLinked(LINK_THIS, efectin, "racial", "effect");
                            llMessageLinked(LINK_THIS, 0, llList2CSV(["hheal", victim, agent]), "effect");
                        } else if (msg == "Ping_Meter") { // Meter ping RX from healing devices
                            llMessageLinked(LINK_THIS, 0, llList2CSV(["hheal_ping", victim, agent]), "effect");
                        }
                    }
                }
            }
        }
    }

   link_message(integer sender, integer num, string lmsg, key id) {

        // Script set-up. Called by Main
        if (id == "EffectInit") {
            initialize(lmsg);
        }

        else if (id == "SkIlLs") {
            handleSkillsMessage(lmsg);
        }

        else if (id == "ctrl") {
            handleControlMessages(lmsg, num);
        }

        else if (id == "onDamageReceived") {
            handleDamageEffects(lmsg);
        }
    }
    
     changed(integer mask)
    {
        if(mask & CHANGED_OWNER){llResetScript();}
    }
}