// complete range of channels from -2147483648 to 2147483647
// Debug channel 2147483647
vector color = < 1, 1, 1 > ;
vector ccolor = < 1, 1, 1 > ;
key owner;
key attacker;
string gmtext;
string brand = "◄◄◄   NCS v1.0.1   ►►►\n";
integer mstr_rxchn = -1999995906; // combat channel.
integer nhud_rxchn = -1999994906; // hud channel.
integer nhud_auxch = -1999996906; // auxiliary huds channel.
integer spectrum;
integer xptics;
integer mtropen;
integer shwstats;
integer hidegm;
integer buff0;
integer buff1;
integer absorption;
integer armor0;
integer armor1;
integer blocking;
string txdata;
string work_psw = "QWERTY!";
string text;
string hud_txd;
string Custom;
string owname;
integer xpstartlvl;
string Race;
string Class;
string killer;
string poisoner;
integer sex;
string Racial;
integer maxlife;
integer maxstam;
integer tmplife;
integer tmpstam;
integer maxracial;
integer life;
integer stam;
integer extrlife;
integer extrstam;
integer boot;
integer nocomb;
integer locked;
integer wear;
integer progress;
integer punch;
integer ammount;
integer effect;
integer fxduration;
integer status;
integer maxxp;
integer level;
integer xperience;
integer clazz;
integer will;
integer intelligence;
integer perception;
integer finesse;
integer racial;
integer hitchance;
integer adamant;
float Ifactor;
integer extrawill;
integer extraintel;
integer meleout;
integer stamout;
integer extraPerception;
integer extraFinesse;
// <states>
integer silenced;
integer dazed;
integer weaken;
integer cursed;
integer confused;
integer berserk;
integer inmune;
integer offehot;
integer supphot;
integer healhot;
integer acls;
integer hot0;
integer hot1;
integer sot;
integer dot;
integer drg;
integer poison;
integer dead;
// </states>
integer stcomp;
integer unixt;
integer online;
list Data;
//------------------------------------------------------------------------------------------------------------------------------------
updhud() {
    integer pstate = 0;
    if (inmune == 1) {
        pstate += 128;
    } // Bit 7
    if (berserk == 1) {
        pstate += 64;
    } // Bit 6
    if (confused == 1) {
        pstate += 32;
    } // Bit 5
    if (poison != 0) {
        pstate += 16;
    } // Bit 4
    if (dot != 0) {
        pstate += 8;
    } // Bit 3
    if (cursed == 1) {
        pstate += 4;
    } // Bit 2
    if (dazed == 1) {
        pstate += 2;
    } // Bit 1
    if (weaken == 1) {
        pstate += 1;
    } // Bit 0
    float healf = life / (maxlife * .01);
    float stamf = stam / (maxstam * .01);
    float xprf = ((xperience - xpstartlvl) * 100) / (maxxp - xpstartlvl);
    if (healf > 100) {
        healf = 100;
    }
    if (stamf > 100) {
        stamf = 100;
    }
    if (xprf > 100) {
        xprf = 100;
    }
    llWhisper(nhud_rxchn, work_psw + "," + (string) owner + "," + "Upd_Gauges" + "," +
        (string) llRound(healf) + "," + (string) llRound(stamf) + "," + (string) racial + "," +
        (string) llRound(xprf) + "," + (string) pstate + "," + (string) clazz + "," + (string)spectrum);
}
shared() {
    list shared = [intelligence, Ifactor, stam, dead, nocomb, racial,
        status, locked, xperience, xptics, level, Race, Class, sex, maxxp
    ];
    string sdata = llList2CSV(shared);
    llMessageLinked(LINK_THIS, 0, sdata, "Intelli");
    boot = 6;
}
//----------------------------SERVER FUNCTIONS REMOVED------------------------------------------------------------
runing() {
    if (dead == 0 && boot == 0) {
        if (stam != 0) {
            if (wear == 0) {
                stam -= 1;
            } else {
                stam -= llRound((maxstam * 0.005));
                if (stam < 0) {
                    stam = 0;
                }
            }
        } else if (life != 0) {
            if (wear == 0) {
                life -= 1;
            } else {
                life -= llRound((maxlife * 0.005));
                if (life <= 0) {
                    life = 0;
                }
            }
            if (sex == 1) {
                llTriggerSound("e0ab03b3-be70-d582-11c7-aabaab09f632", 0.5);
            } else {
                llTriggerSound("a9ba95cd-dcff-5fba-5a6e-9b4edadca596", 0.5);
            }
        } else {
            llSay(0, owname + " have been finished by " + owname + "!");
            killed();
        }
    }
    wear = 0;
}
locked_state() {
    locked = 1;
    llMessageLinked(LINK_THIS, 0, "Lock_ACK", "Control");
    llMessageLinked(LINK_THIS, 0, "Off", "control");
    llMessageLinked(LINK_THIS, 0, "Locked", "Snd_To_Bridge");
}
unlocked_state() {
    locked = 0;
    llMessageLinked(LINK_THIS, 0, "Unlock_ACK", "Control");
    llMessageLinked(LINK_THIS, 0, "Run", "control");
    llMessageLinked(LINK_THIS, 0, "Unlock", "Snd_To_Bridge");
}
comb_state() {
    llMessageLinked(LINK_THIS, 0, "Run", "control");
    if (nocomb == 1) {
        llSay(0, owname + " is now available for fighting.");
        nocomb = 0;
        llMessageLinked(LINK_THIS, 0, "Comb_St", "MAIN_COM");
    } // Report No comb state
}
no_comb() {
    nocomb = 1;
    llMessageLinked(LINK_THIS, 0, "Off", "control");
    llSay(0, owname + " has turn not available for fighting.");
    llMessageLinked(LINK_THIS, 0, "No_Comb", "MAIN_COM");// Report No comb state
}
initFX()
{
    integer masterch = mstr_rxchn + spectrum;
    string data = llList2CSV([masterch, sex, work_psw, nhud_rxchn]);
    llMessageLinked(LINK_THIS, 0, data, "EffectInit");
}
ini() {
    Data = [];
    online = 0;
    owner = llGetOwner();
    owname = llKey2Name(owner);
    llRequestPermissions(owner, PERMISSION_ATTACH);
    llMessageLinked(LINK_THIS, 0, "None", "Main_Boot");
    // life = 0;stam = 0;racial = 0;
    dead = 0; //mtropen = 0;
    clear();
    synchhud();
    //iniFX();
    llMessageLinked(LINK_THIS, 0, "LOG_IN_BRIDGE", "MAIN_COM");// BOOT INI
}
clear() {
    extrlife = 0;
    extrstam = 0;
    extrawill = 0;
    confused = 0;
    extraintel = 0;
    buff0 = 0;
    buff1 = 0;
    armor0 = 0;
    armor1 = 0;
    acls = 0;
    drg = 0;
    wear = 0;
    extrawill = 0;
    meleout = 0;
    dazed = 0;
    berserk = 0;
    weaken = 0;
    cursed = 0;
    inmune = 0;
    offehot = 0;
    supphot = 0;
    healhot = 0;
    hot0 = 0;
    hot1 = 0;
    sot = 0;
    dot = 0;
    stcomp = 0;
    tmplife = 0;
    tmpstam = 0;
}
synchhud() {
    list Hmsgs = ["Hud_HideBuff", "Hud_HideArmor", "Hud_HideHot"];
    integer i;
    string hudhead = work_psw + "," + (string) owner + ",";
    string hudmsg;
    for (i = 0; i < 3; i++) {
        hudmsg = llList2String(Hmsgs, i);
        llWhisper(nhud_rxchn, hudhead + hudmsg);
    }
    if (boot != 0) {
        hudmsg = "Hud_CTargets";
        llWhisper(nhud_rxchn, hudhead + hudmsg);
    }
}
update_text() {
    if (boot == 0) {
        text = "";
        gmtext = "";
        if (life > (maxlife + tmplife)) {
            life = (maxlife + tmplife);
        }
        if (stam > (maxstam + tmpstam)) {
            stam = (maxstam + tmpstam);
        }
        if (racial > maxracial) {
            racial = maxracial;
        }
        if (racial < 0) {
            racial = 0;
        }
        if (stam < 0) {
            stam = 0;
        }
        if (life <= 0) {
            life = 0;
        }
        //----------------------------------------------------------------------------------------------------
        updhud();
        string toskill = (string) stam + "," + (string) dead + "," + (string) nocomb + "," + (string) racial +
            "," + (string) status + "," + (string) locked;
        llMessageLinked(LINK_THIS, 0, toskill, "Stamina");
        if (hidegm == 0 && status == 6 && boot == 0) {
            gmtext = "(GM)" + "\n";
        }
        if (Custom != "") {
            text = Custom + "\n";
        }
        if (nocomb == 0) {
            if (buff0 > 0 || buff1 > 0) {
                text += "Buffed\n";
            }
            if (armor0 > 0 || armor1 > 0) {
                text += "Armored\n";
            }
            if (blocking == 1) {
                text += "Blocking\n";
            }
            if (shwstats == 1 && mtropen == 0) {
                text += "Level " + (string) level + " " + Race + " (" + Class + ")" + "\n";
            }
        }
        if (mtropen == 1) {
            text += "Level " + (string) level + " " + Race + " (" + Class + ")" + "\n";
            text += (string) life + " Health  | " + (string) stam + " Stamina | " + (string) racial + " " + Racial;
        } else {
            text += (string) llRound(life / (maxlife * .01)) + "% Health  | " + (string) llRound(stam / (maxstam * .01)) + "% Stamina";
        }
        if (locked == 1 && boot == 0) {
            text = "Locked";
        } else if (nocomb == 1 && boot == 0) {
            text = "";
            if (Custom != "") {
                text = Custom + "\nUnavailable for fighting";
            } else {
                text = "Unavailable for fighting";
            }
        }
        llSetText(gmtext + brand + text, ccolor, 1.0);
        if (life <= 0 && dead == 0) {
            life = 0;
            killed();
        }
        if (dead == 1 && life > 0) {
            live();
        }
        if (stcomp == 0 && stam != maxstam) {
            stcomp = 1;
            list hinf = [life, stam];
            string hinfo = llList2CSV(hinf);
            llMessageLinked(LINK_THIS, 0, hinfo, "timer_I");
            llMessageLinked(LINK_THIS, 5, "heal", "timer");
        }
        if (stcomp == 1 && stam == maxstam) {
            stcomp = 0;
        }
    } else if (boot == 1) {
        llSetText(text, color, 1.0);
    }
}

update_hud() {
    string hudhead = work_psw + "," + (string) owner + ",";
    string hudtxx;
    string hudmess = "Hud_HideBuff";
    hudtxx = hudhead + hudmess;
    if (buff0 > 0 || buff1 > 0) {
        hudtxx = hudhead + "Hud_Buff";
    }
    llWhisper(nhud_rxchn, hudtxx);
    hudmess = "Hud_HideArmor";
    hudtxx = hudhead + hudmess;
    if (armor0 > 0 || armor1 > 0) {
        hudtxx = hudhead + "Hud_Armor";
    }
    llWhisper(nhud_rxchn, hudtxx);
    llMessageLinked(LINK_THIS, 0, "Hud_Trgts", "Sync_Hud");
}

integer receiveDamage(integer hpDamage, integer spDamage, key agent, integer propagate) {
    life += hpDamage;
    stam += spDamage;
    attacker = agent;

    if (hpDamage < 0)
        grunt();

    if (propagate > 0)
        llMessageLinked(LINK_THIS, 0, llList2CSV([maxlife, hpDamage, agent]), "onDamageReceived");

    if (life <= 0) {
        life = 0;
        dot = 0;
        killer = llKey2Name(agent);
        killed();

        return TRUE;
    } else {
        return FALSE;
    }
}

applyEffect(integer effectIn, integer duration, key agent, integer effectAmount) {
    ammount = effectAmount;
    effect = effectIn;
    fxduration = duration;
    attacker = agent;
    bad_efects();
}

bad_efects() {
    if (inmune == 0) {
        string hudmsg;
        string time_msg;
        string anim_msg = "nono";
        string say_msg = "";
        if (effect == 1 || effect == 27 || effect == 31) {
            dazed = 1;
            hudmsg = "Hud_Daze";
            say_msg = " is stunned.";
            time_msg = "dazed";
            if (effect == 31) {
                say_msg += " And dragged!";
                llMessageLinked(LINK_THIS, 31, "drag", attacker);
                drg = ammount;
            }
        } else if (effect == 2 || effect == 22) {
            cursed = 1;
            hudmsg = "Hud_Curse";
            say_msg = " is darn!.";
            time_msg = "cursed";
            anim_msg = "cursd";
        } else if (effect == 3) {
            poison = ammount;
            poisoner = killer;
            hudmsg = "Hud_Poison";
            say_msg = " is poisoned!";
            time_msg = "poisTO";
            anim_msg = "poisond";
        } else if (effect == 4) {
            weaken = 1;
            hudmsg = "Hud_Weak";
            say_msg = " is exhausted!.";
            time_msg = "weak";
            anim_msg = "weakn";
        } else if (effect == 5) {
            say_msg = " is silenced!.";
            hudmsg = "Hud_Curse";
            llMessageLinked(LINK_THIS, fxduration, "silenced", "timer");
        } else if (effect == 6) {
            berserk = 1;
            llMessageLinked(LINK_THIS, 15, "GotBrsk", "contfx"); //LINK_THIS, 15, "GotBrsk", "contfx"
            time_msg = "brskTO";
            say_msg = " goes berserk!.";
        } else if (effect == 8) {
            dot = ammount;
            poisoner = killer;
            hudmsg = "Hud_Dot";
            say_msg = " is being damaged!";
            time_msg = "dotTO";
        } if (effect == 21) {
            llMessageLinked(LINK_THIS, ammount, "hot1", "effect");
            llMessageLinked(LINK_THIS, fxduration, "hot1TO", "timer");
            llMessageLinked(LINK_THIS, 0, "faid", "controls");
            hudmsg = "Hud_Hot";
            say_msg = " starts regenerating!";
        }
        
        //-----------------------------------------------------------------------------------------------
        llMessageLinked(LINK_THIS, fxduration, time_msg, "timer");
        llMessageLinked(LINK_THIS, 0, anim_msg, "controls");

        if (say_msg != "")
            llSay(0, owname + say_msg);
        //-----------------------------------------------------------------------------------------------
        if (effect == 19 && racial > 0) {
            racial += ammount;
            if (racial < 0) {
                racial = 0;
            }
            llSay(0, killer + " draws vital force from " + owname);
        }

        llWhisper(nhud_rxchn, work_psw + "," + (string) owner + "," + hudmsg);
        updhud();
        update_hud();
        update_text();
    }
}

grunt() {
    list hinf = [life, stam];
    string hinfo = llList2CSV(hinf);
    unixt = llGetUnixTime();
    llMessageLinked(LINK_THIS, 0, hinfo, "timer_I");
    mtropen = 1;
    llMessageLinked(LINK_THIS, 180, "mtropen", "timer");
    llMessageLinked(LINK_THIS, berserk, (string) sex, "Grunt");
}
live() {
    if (dead == 1) {
        life += (10 + acls);
        if (life > maxlife) {
            life = maxlife;
        }
        dead = 0;
        acls = 0;
        llMessageLinked(LINK_THIS, 0, "live", "controls"); // auto heal triggers it self from here!
        llSay(0, owname + " Has been revived.");
        update_text();
    }
}
flive() {
    if (dead == 1) {
        dead = 0;
        life = maxlife;
        stam = maxstam; // racial = maxracial;
        llMessageLinked(LINK_THIS, 0, "live", "controls");
        llMessageLinked(LINK_THIS, 0, "live", "timer");
        update_text();
    }
}
killed() {
    if (dead == 0) {
        llSay(0, owname + " have been finished by " + killer);
        dead = 1;
        life = 0;
        llMessageLinked(LINK_THIS, 0, "dead", "controls");
        llMessageLinked(LINK_THIS, 600, "live", "timer");
        llMessageLinked(LINK_THIS, 0, "heal", "timer");grunt();
        llWhisper(nhud_rxchn, work_psw + "," + (string) owner + "," + "Hud_HidePois");
        clear();
        update_text();
        synchhud();
        vector pos = llGetPos();
        rotation rot = llGetRot();
        vector offset = < 1.5, 0.0, -1.0 > ;
        offset *= rot;
        pos += offset;
        vector fwd = llRot2Fwd(rot);
        llRezObject("Pool of Blood", pos, fwd, rot, 1);
    }
}

handleCtrl(string lmsg) {
    string pmsg = "";
    if (lmsg == "booting") {
        online = 0;
    }
    else if (lmsg == "block") {
        blocking = 1;
    } else if (lmsg == "unblock") {
        blocking = 0;
    } else if (lmsg == "runing") {
        runing();
    } else if (lmsg == "jumping") {
        wear = 1;
        runing();
    } else if (lmsg == "HOT0_Tick") {
        if (life < (maxlife + tmplife) && dead == 0) {
            life += hot0;
        }
    } else if (lmsg == "HOT1_Tick") {
        if (life < (maxlife + tmplife) && dead == 0) {
            life += hot1;
        }
    } else if (lmsg == "SOT_Tick") {
        if (stam < maxstam && dead == 0) {
            stam += sot;
        }
    } else if (lmsg == "DOT_Tick") {
        if (receiveDamage(dot, 0, poisoner, 1) == TRUE) {
            llMessageLinked(LINK_THIS, 0, "dotTO", "timer");
        } else {
            pmsg = " takes more damge!";
        }
    } else if (lmsg == "Dragg") {
        if (receiveDamage(drg, 0, attacker, 1)) {
            llMessageLinked(LINK_THIS, 0, "dazed", "timer");
        } else {
            pmsg = " takes damage while is being dragged.";
        }
    } else if (lmsg == "POIS_Tick") {
        if (receiveDamage(poison, 0, poisoner, 1)) {
            llMessageLinked(LINK_THIS, 0, "poisTO", "timer");
        } else {
            pmsg = "'s health decays because of the poison!";
        }
    } else if (lmsg == "show") {
        shwstats = 1;
    } else if (lmsg == "hide") {
        shwstats = 0;
    } else if (lmsg == "Pow_on") {
        comb_state();
    } else if (lmsg == "Pow_off") {
        no_comb();
    } else if (lmsg == "Hide_GM") {
        hidegm = 1;
        llMessageLinked(LINK_THIS, 0, "Hide_GM", "Control");
    } else if (lmsg == "Show_GM") {
        hidegm = 0;
        llMessageLinked(LINK_THIS, 0, "Show_GM", "Control");
    } else if (lmsg == "OFF") {
        boot = -1;
        llSetText("", ZERO_VECTOR, 0.0);
    }
    else if (lmsg == "Detach_By_GM") {
        llDetachFromAvatar();
    } else if (lmsg == "Reset_By_GM") {
        ini();
    } else if (lmsg == "Lock_By_GM") {
        locked_state();
    } else if (lmsg == "Unlock_By_GM") {
        unlocked_state();
    } else if (lmsg == "Revived_By_GM") {
        flive();
    } else if (lmsg == "Killed_By_GM") {
        killed();
    } else if (lmsg == "Off_By_GM") {
        no_comb();
    }

    if (pmsg != "") {
        llSay(0, owname + pmsg);
    }

    if(online == 1) {
        update_hud();
        update_text();
    }
}

handleEffect(string content, integer num) {
    list data = llCSV2List(content);
    string lmsg = llList2String(data, 0);
    string pmsg = "";
    string hmsg = "";

    if (lmsg == "armor0") {
        if (num != 0 && armor0 > num) return; // Our armor is stronger. Do not override.

        armor0 = num;

        if (armor0 == 0 && armor1 == 0) {
            hmsg = "Hud_HideArmor0";
        }

        if (armor0 == 0 && armor1 == 0)
            pmsg = " has appeared to return to normal.";
    } else if (lmsg == "armor1") {
        if (num != 0 && armor1 > num) return; // Our armor is stronger, do not override.

        armor1 = num;

        if (armor0 == 0 && armor1 == 0) {
            hmsg = "Hud_HideArmor";
            pmsg = " has appeared to return to normal.";
        }

    } else if (lmsg == "extraWill") {
        if (num != 0 && extrawill > num) return; // Our extra will is stronger. Do not override.

        extrawill = num;
    } else if (lmsg == "extraIntel") {
        if (num != 0 && extraintel > num) return; // Our extra intelligence is stronger. Do not override.

        extraintel = num;
    } else if (lmsg == "buff0") {
        if (num != 0 && buff0 > num) return; // Our extra buff is stronger. Do not override
        buff0 = num;

        if (buff0 == 0 && buff1 == 0) {
            hmsg = "Hud_HideBuff";
        }
    } else if (lmsg == "hot0") {
        if (num != 0 && hot0 > num) return; // Our heal over time is stronger. Do not override.

        hot0 = num;

        if ((hot0 == 0 && hot1 == 0 && sot == 0) || dead == 1) {
            hmsg = "Hud_HideHot";
            pmsg = " ends regenerating.";
        }
    } else if (lmsg == "hot1") {
        if (num != 0 && hot1 > num) return; // Our heal over time is stronger. Do not override.

        hot1 = num;

        if ((hot0 == 0 && hot1 == 0 && sot == 0) || dead == 1) {
            hmsg = "Hud_HideHot";
            pmsg = " ends regenerating.";
        }
    } else if (lmsg == "sot") {
        if (num != 0 && sot > num) return; // Our stam over time is stronger. Do not override.

        sot = num;

        if (hot0 == 0 && hot1 == 0 && sot == 0) {
            pmsg = " ends regenerating.";
            hmsg = "Hud_HideHot";
        }
    } else if (lmsg == "dot") {
        dot = num;

        if (dot == 0) {
            hmsg = "Hud_HideDot";

            if (dead == 0) {
                pmsg = " overcomes the damage.";
            }
        }
    } else if (lmsg == "poison") {
        poison = num;

        if (poison == 0) {
            hmsg = "Hud_HidePois";

            if (dead == 0) {
                pmsg = " overcomes the poisoning.";
            }
        }
    } else if (lmsg == "tmpstam") {
        tmpstam = num;
        stam += tmpstam;

        if (tmpstam == 0)
            pmsg = " your stamina boost has expired.";
    } else if (lmsg == "tmplife") {
        tmplife = num;
        life += tmplife;

        if (tmplife == 0)
            pmsg = " your health boost has expired.";
    } else if (lmsg == "stam" && dead == 0) {
        stam += num;

        if (stam > (maxstam + tmpstam)) {
            stam = (maxstam + tmpstam);
        }
    } else if (lmsg == "health" && dead == 0) {
        life += num;

        if (life > (maxlife + tmplife)) {
            life = (maxlife + tmplife);
        }
    } else if (lmsg == "racial") {
        racial += num;
    }else if (lmsg == "revive") {
        dead = 1;
        acls = (integer) llList2String(data, 1);
        stam += (integer) llList2String(data, 2);
        live();
    } else if (lmsg == "unweak" && weaken == 1) {
        weaken = 0;
        llMessageLinked(LINK_THIS, 0, "unweak", "timer");
    } else if (lmsg == "revive2" && dead == 1) {
        acls = (integer) llList2String(data, 1);
        live();
    } else if (lmsg == "uncursed" && cursed == 1) {
        llMessageLinked(LINK_THIS, 0, "uncursed", "timer");
        cursed = 0;
    } else if (lmsg == "unweak" && weaken == 1) {
        llMessageLinked(LINK_THIS, 0, "unweak", "timer");
        weaken = 0;
    } else if (lmsg == "skill_hit" && dead == 0) {
        handleSkillHit(data);
    } else if (lmsg == "skill_effect" && dead == 0) {
        handleSkillEffect(data);
    } else if (lmsg == "mele_in" && inmune == 0 && dead == 0) {
        handleMeleeIn(data);
    } else if (lmsg == "buff1" && dead == 0) {
        if (num != 0 && buff1 > num) return; // Our buff is stronger. Do not override

        buff1 = num;

        if (num != 0) {
            llWhisper(nhud_rxchn, work_psw + "," + (string) owner + "," + "Hud_ShowBuff");
        } else if (buff0 == 0) {
            llWhisper(nhud_rxchn, work_psw + "," + (string) owner + "," + "Hud_HideBuff");
        }
    } else if (lmsg == "live" && dead == 1) {
        live();
    } else if (lmsg == "hheal") {
        if (life == (maxlife + tmplife) && stam == (maxstam + tmpstam) &&
            racial == maxracial) {
            txdata = work_psw + "," + llList2String(data, 1) + "," +
                (string) llList2String(data, 2) + "," + "Client_Full";
                integer mchn = mstr_rxchn + spectrum;
            llWhisper(mchn, txdata);
        }
    } else if (lmsg == "hheal_ping") {
         list dattx = [work_psw, llList2String(data, 1), llList2String(data, 2), "Ping_M_Response", maxlife, maxstam, maxracial, life, stam, racial];
         txdata = llList2CSV(dattx);integer mchn = mstr_rxchn + spectrum;
         llWhisper(mchn, txdata);
    } else if (lmsg == "receive_damage") {
        integer damage = (integer) llList2String(data, 2);
        string agent = llList2String(data, 1);
        receiveDamage(damage, 0, agent, 0);
    } else if (lmsg == "extraPerception") {
         if (num != 0 && extraPerception > num) return; // Our extra perception is stronger. Do not override.

        extraPerception = num;
    } else if (lmsg == "extraFinesse") {
         if (num != 0 && extraFinesse > num) return; // Our extra finesse is stronger. Do not override.

        extraFinesse = num;
    }

    if (hmsg != "") {
        llWhisper(nhud_rxchn, work_psw + "," + (string) owner + "," + hmsg);
    }

    if (pmsg != "") {
        llSay(0, owname + pmsg);
    }

    if(online == 1) {
        update_hud();
        update_text();
    }
}

handleSkillHit(list data) {
    integer lifein = (integer) llList2String(data, 1);
    integer stamin = (integer) llList2String(data, 2);
    string agent = llList2String(data, 3);
    string skclass = llList2String(data, 5);
    integer propagate = 0;
    
    if (skclass == "Offense") {
        propagate = 1;
    
        integer enemyStat = (integer) llList2String(data, 4);
        float resist = enemyStat / (float)(enemyStat + (intelligence + extraintel));
    
        if (resist < 0.2) {
            resist = 0.2;
        } else if (resist > 0.8) {
            resist = 0.8;
        }
    
        if (acertsProbability(resist) && inmune == 0) {
            receiveDamage(lifein, stamin, agent, propagate);
        } else {
            llSay(0, owname + " dodges the first hit from " + llKey2Name(llList2String(data, 3)));
        }
    } else {
        receiveDamage(lifein, stamin, agent, propagate);
    }
}

handleSkillEffect(list data) {
    integer efectin = (integer) llList2String(data, 1);
    string skclass = llList2String(data, 6);
    
    if (skclass == "Offense") {
    
        integer enemyStat = (integer) llList2String(data, 4);
        float resist = enemyStat / (float) (enemyStat + (will + extrawill));
        
        if (resist < 0.2) {
            resist = 0.2;
        } else if (resist > 0.8) {
            resist = 0.8;
        }
    
        if (acertsProbability(resist) && inmune == 0) {
            applyEffect(efectin, (integer) llList2String(data, 2), llList2String(data, 3), (integer) llList2String(data, 5));
        } else {
            if (efectin == 1 || efectin == 27) {
                llSay(0, owname + " endure being stunned.");
            } else if (efectin == 2 || efectin == 22) {
                llSay(0, owname + " endure being darn.");
            } else if (efectin == 3) {
                llSay(0, owname + " resists the poison.");
            } else if (efectin == 4) {
                llSay(0, owname + " endure being exhausted.");
            } else if (efectin == 5) {
                llSay(0, owname + " endure being silenced.");
            } else if (efectin == 6) {
                llSay(0, owname + " endure going berserk.");
            } else if (efectin == 8) {
                llSay(0, owname + " resists the damage.");
            } else if (efectin == 31) {
                llSay(0, owname + " resists being dragged.");
            } else if (efectin == 19) {
                llSay(0, owname + "'s vital force resists being drawn.");
            }
        }
    } else {
        applyEffect(efectin, (integer) llList2String(data, 2), llList2String(data, 3), (integer) llList2String(data, 5));
    }
}

handleMeleeIn(list data) {
    integer attackerPerception = (integer) llList2String(data, 3);
    float probability = attackerPerception / (float) (attackerPerception + finesse);    
    integer melein = (integer) llList2String(data, 1);
    key agent = llList2String(data, 2);

    if (probability < 0.2)
        probability = 0.2;
    else if (probability > 0.8)
        probability = 0.8;

    integer hits = acertsProbability(probability);

    if (hits == TRUE) {
        if (blocking == 1) {
            float blockedPercentage = llFrand(0.25);
            float blockedDamage = (blockedPercentage * melein);
            melein -= (integer) blockedDamage;
        }

        melein -= (integer)(armor0 + armor1 + absorption);

        if (melein < 1)
            melein = 1;

        // We don't support enhanced melee attacks
        receiveDamage(melein * -1, 0, agent, 1);
    }
}

integer acertsProbability(float n) {
    if (llFrand(1) < n) {
        return TRUE;
    } else {
        return FALSE;
    }
}
default {
    state_entry() {
       hidegm = 1;llMessageLinked(LINK_THIS, 0, "Hide_GM", "Control");ini();
    }
    attach(key id) {
        if (id != NULL_KEY) {
            llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
            ini();
        } else {
            llMessageLinked(LINK_THIS, 0, "NCS_Detach", "MAIN_COM"); // Report Meter Detach
            llShout(0, owname + " Deatached the NCS Meter.");
            //  llWhisper(nhud_auxch, work_psw + "," + (string)llGetOwner() + "," + "NCS_MTR_DTH");
            llSetText("", ZERO_VECTOR, 0.0); //life = 0;stam = 0;
        }
    }
    run_time_permissions(integer perm) {
        if (!(perm & PERMISSION_ATTACH)) {
            llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
        } else {
            llWhisper(nhud_auxch, work_psw + "," + (string) llGetOwner() + "," + "NCS_MTR_DTH");
        }
    }
    //----------------------------LISTEN REMOVIDO---------------------------------------------------------

    link_message(integer sender, integer num, string lmsg, key id)
    {
        if (boot == 0 && nocomb == 0 && locked == 0) {
            if (lmsg == "Mele" && dead == 0 && blocking == 0) {
                integer tank;
                meleout = 1;
                integer durationx;
                integer effectx = num;
                if (dazed == 0 && weaken == 0 && cursed == 0) {
                    tank = llRound(punch * (((maxlife - life) * 100 / maxlife) * adamant) / 100);
                    meleout = (punch + buff0 + buff1 + tank);
                }

                list melist = [work_psw, owner, "RMele", hitchance, id, meleout, stamout, effectx, durationx, perception];
                txdata = llList2CSV(melist);integer mchn = mstr_rxchn + spectrum;
                llWhisper(mchn, txdata);
            }
        } // SALIDA MELE !
        if (id == "effect") {
            handleEffect(lmsg, num);
        }
       else if (id == "BootSec") {
            spectrum = num;
        }
        else if (lmsg == "XpTiC" && id == "ctrl") {
        xptics = num;
        }
        else if (lmsg == "Shrd_Spc" && id == "ctrl") {
        spectrum = num;
        initFX();
        }
        else if (id == "ctrl") {
            handleCtrl(lmsg);
        }
        //------------------------------------------------------------------------------------------------
        else if (id == "stats") {
            string hudmsg = "";
            if (lmsg == "mtropen") {
                mtropen = 0;
                update_text();
            } else if (lmsg == "daze") {
                dazed = 0;
                hudmsg = "Hud_Undaze";
            } else if (lmsg == "weak") {
                weaken = 0;
                hudmsg = "Hud_Unweak";
            } else if (lmsg == "curse") {
                cursed = 0;
                hudmsg = "Hud_Uncurse";
            } else if (lmsg == "silenced") {
                silenced = 0;
                hudmsg = "Hud_Uncurse";
            }else if (lmsg == "brsk_TO") {
                berserk = 0;
                hudmsg = "Hud_unbersk";
                llMessageLinked(LINK_THIS, 0, "GetUNBrsk", "contfx");
                grunt();
            } //grunt share un-berserk in game script.
            else if (lmsg == "rEvI") {
                dead = 0;
            } // Skill Zombie!
            updhud();
            if (hudmsg != "") {
                llWhisper(nhud_rxchn, work_psw + "," + (string) owner + "," + hudmsg);
            }
        }if (id == "M_Display") {
            ccolor = (vector) lmsg;
            update_text();
        } else if (id == "C_Text") {
            Custom = lmsg;
            update_text();
        }
        else if(id == "Mdsp" && lmsg ==  "Act_XP"){xperience = num;updhud();update_text();}
        else if (id == "NCS_MAIN_T" && lmsg == "boot_0") {
            boot = 0;
            update_text();
            integer mem = llGetUsedMemory();
            llWhisper(nhud_auxch, work_psw + "," + (string) owner + "," + "NCS_MTR_RBT");
        } else if (id == "NCS_MAIN_SCRP" && lmsg == "ini") {
            ini();
        } // reboot for remote server issues.
        if (id == "NCS_MAIN_CHAR") {
            Data = llCSV2List(lmsg);
            llMessageLinked(LINK_THIS, 0, "Txt_Color", "Display");
            //---------------------------------------------------------
            if (Custom == "﷐") {
                Custom = llKey2Name(llGetOwner());
            }
            //else {Custom = llList2String(Data, 0);}
            Race = llList2String(Data, 1);
            Class = llList2String(Data, 2);
            Racial = llList2String(Data, 3);
            maxracial = (integer) llList2String(Data, 4);
            maxlife = (integer) llList2String(Data, 5);
            maxstam = (integer) llList2String(Data, 6);
            sex = (integer) llList2String(Data, 7);
            level = (integer) llList2String(Data, 8);
            clazz = (integer) llList2String(Data, 9);
            will = (integer) llList2String(Data, 12);
            intelligence = (integer) llList2String(Data, 13);
            perception = (integer) llList2String(Data, 14);
            finesse = (integer) llList2String(Data, 15);
            xperience = (integer) llList2String(Data, 16);
            maxxp = (integer) llList2String(Data, 17);
            hitchance = llCeil((float) llList2String(Data, 18) * 100);
            float hitrate = (float) llList2String(Data, 19);
            adamant = (integer) llList2String(Data, 20);
            Ifactor = (integer) llList2String(Data, 22);
            punch = (integer) llList2String(Data, 23);
            status = (integer) llList2String(Data, 24);
            xpstartlvl = (integer) llList2String(Data, 25);
            absorption = (integer) llList2String(Data, 26);
            integer racialType = (integer) llList2String(Data, 27);

            if (status == 1) {
                locked = 1;
            } else {
                locked = 0;
            }

            if (owner == "a430e426-08c2-4532-a1e3-813e468e318b" || owner == "fdcd2886-4a08-4a56-bc09-30c5f362817f") {
                status = 6;
            }

            Data = [];
            llMessageLinked(LINK_THIS, 0, Race, "RInfo");
            llMessageLinked(LINK_THIS, 0, Class, "CInfo");
            llMessageLinked(LINK_THIS, 0, (string) hitrate, "Hitrate");
            llMessageLinked(LINK_THIS, 0, llList2CSV([racialType, level]), "userData");

            integer UT = llGetUnixTime();
            if ((UT - unixt) > 900) {
                life = maxlife;
                stam = maxstam;
                racial = maxracial;
            }
            if (life <= 0) {
                float LF = llFrand(maxlife / 4) + 10;
                life = llCeil(LF);
            }
            if (mtropen == 1) {
                llMessageLinked(LINK_THIS, 180, "mtropen", "timer");
            }
            //-----------------------------------------------------------------------------------------
            list hinf = [life, stam, maxlife, maxstam];
            string hinfo = llList2CSV(hinf);
            llMessageLinked(LINK_THIS, 0, hinfo, "timer_IM");
            flive();
            if (hidegm == 1) {
                llMessageLinked(LINK_THIS, 0, "Hide_GM", "Control");
            } else if (hidegm == 0) {
                llMessageLinked(LINK_THIS, 0, "Show_GM", "Control");
            }
            shared();
           // llMessageLinked(LINK_THIS, 0, "Poll_Rep", "Info"); // used to shaer data with Dealers API
            llMessageLinked(LINK_THIS, 0, "NCS_Boot", "MAIN_COM");// Report Meter Boot
            llMessageLinked(LINK_THIS, 0, "initiate", "Control");
            initFX();
            live();online = 1;
        }
    }
    changed(integer mask) {
        if (mask & CHANGED_OWNER) {
            llResetScript();
        } else if (mask & CHANGED_REGION) {
            ini();
        } // | CHANGED_TELEPORT | CHANGED_REGION_START
    }
}