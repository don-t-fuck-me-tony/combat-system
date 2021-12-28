float time;
integer rezed;
integer tcomp;
integer offecool;
integer suppcool;
integer healcool;
integer mtropen;
integer hnum; //auto-heal
integer maxlife;
integer maxstam;
integer life;
integer stam;
integer healcount;
integer live;
integer heal;
integer silenced;
integer dazed;
integer cursed;
integer poison;
integer poisTO;
integer weak;
integer guard;
integer hot0;
integer hot1;
integer sot;
integer hot0TO;
integer hot1TO;
integer sotTO;
integer dot;
integer dotTO;
integer tmplifeTO;
integer tmpstamTO;
integer brskTO;
integer ticks;
integer tickset = 120;
integer recovery = 5;
integer menutim;
integer parti;
integer partia;
integer partib;
integer partic;
integer partiw;
integer partip;
integer partil;
integer partiz;
integer block;
integer onair;
integer armor0TO;
integer armor1TO;
integer tempStatTO;
integer buff0TO;
integer buff1TO;
integer reflectTO;
integer racial;
integer racialTO;
integer racialDamage;
integer Jump_T;
integer retry;
integer BTO;
integer SBWD;
string owname;
integer userLevel = 0;
key owner;

ini() {
    owner = llGetOwner();
    owname = llKey2Name(llGetOwner());
    hnum = 1;
    healcount = 0;
    offecool = 0;
    suppcool = 0;
    healcool = 0;
    dazed = 0;
    recovery = 5;
    cursed = 0;
    poison = 0;
    weak = 0;
    guard = 0;
    block = 0;
    hot0 = 0;
    hot1 = 0;
    dot = 0;
    tempStatTO = 0;
    armor0TO = 0;
    armor1TO = 0;
    buff0TO = 0;
    buff1TO = 0;
    racialTO = 0;
    racialDamage = 0;
    ticks = (tickset * 2);
}
chkheight() {
    vector pos = llGetPos();
    float Z = pos.z;
    if (Z > 2020.0) {
        llOwnerSay("Meters can't work over 2000 meters hi. Your Meter will detach now! ");
        llMessageLinked(LINK_THIS, 0, "Detach_By_GM", "ctrl");
    }
   // llMessageLinked(LINK_THIS, 0, "Poll_Rep", "Info"); commented (was to update Dealers API)
}
auto_heal() {
    if (stam < maxstam || life < maxlife) {
        llMessageLinked(LINK_THIS, hnum, "heal", "ctrl");
        healcount += 1;
        if (healcount >= 192) {
            hnum = 256;
            healcount = 192;
        } else if (healcount > 192) {
            hnum = 128;
        } else if (healcount > 168) {
            hnum = 64;
        } else if (healcount > 144) {
            hnum = 32;
        } else if (healcount > 120) {
            hnum = 16;
        } else if (healcount > 96) {
            hnum = 8;
        } else if (healcount > 72) {
            hnum = 4;
        } else if (healcount > 48) {
            hnum = 2;
        }
        if (healcount > 24) {
            llMessageLinked(LINK_THIS, hnum, "heal_1", "ctrl");
        }
    } else {
        heal = 0;
        hnum = 1;
        recovery = 5;
    }
}

norez() {
    llSetTimerEvent(0.0);
    llSay(0, "YOU DONT HAVE PERMISSION TO REZ THIS METER... MESSAGE WAS SENT TO CREATOR!");
    llInstantMessage("a430e426-08c2-4532-a1e3-813e468e318b", llKey2Name(llGetOwner()) + " Intento Rezear el " + llGetObjectName() + " En: " + llGetRegionName() + " A las " + llGetTimestamp());
    llSleep(1.5);
    llDie();
}

handleDamage(string lmsg) {
    if (racial <= 0 || userLevel <= 0) return;

    if (racial > 0) {
        list data = llCSV2List(lmsg);
        racialDamage += (integer) llList2String(data, 1);
        integer maxLife = (integer) llList2String(data, 0);
        integer threshold = llRound(maxLife * 0.25);

        if (racialDamage * -1 >= threshold) {
            // Send racial increase
            integer factor = llRound((userLevel / 15));
            
            if (factor < 1)
                factor = 1;
            
            llMessageLinked(LINK_THIS, racial * factor, "racial", "effect");
            racialDamage = 0;
            racialTO = racial * 10;
        }
    }
}

storeUserData(string lmsg) {
    list data = llCSV2List(lmsg);
    racial = ((integer) llList2String(data, 0));
    userLevel = (integer) llList2String(data, 1);
}

default {
    state_entry() {
        ini();
    }
    attach(key attached) {
        if (attached != NULL_KEY) {
            llSetTimerEvent(0.0);
            rezed = 0;
            ini();
        } else {
            rezed = 0;
            llSetTimerEvent(0.0);
        }
    }
    on_rez(integer param) {
        llSetTimerEvent(0.5);
        rezed = 1;
    }
    link_message(integer sender, integer num, string lmsg, key id) {
        num *= 2;
        if (id == "timer_I") {
            list tdata = llCSV2List(lmsg);
            life = (integer) llList2String(tdata, 0);
            stam = (integer) llList2String(tdata, 1);
        }
        if (id == "timer_IM") {
            list tdata = llCSV2List(lmsg);
            life = (integer) llList2String(tdata, 0);
            stam = (integer) llList2String(tdata, 1);
            maxlife = (integer) llList2String(tdata, 2);
            maxstam = (integer) llList2String(tdata, 3);
        } else if (id == "cooldown") {
            if (lmsg == "heal") {
                healcool = num;
            } else if (lmsg == "supp") {
                suppcool = num;
            } else if (lmsg == "offe") {
                offecool = num;
            }
        } else if (id == "timer") {
            if (lmsg == "dazed") {
                dazed = num;
            } else if (lmsg == "cursed") {
                cursed = num;
            } else if (lmsg == "brskTO") {
                brskTO = num;
            } else if (lmsg == "uncursed") {
                cursed = 0;
                llSay(0, owname + " is no longer darn.");
            } else if (lmsg == "weak") {
                weak = num;
            } else if (lmsg == "unweak") {
                weak = 0;
                llSay(0, owname + " is no longer exhausted.");
            } else if (lmsg == "silenced") {
                silenced = num;
                llMessageLinked(LINK_THIS, num, "silenced", "Skills");
            } else if (lmsg == "mtropen") {
                mtropen = num;
                healcount = 0;
                recovery = 5;
                hnum = 1;
                heal = 10;
                if (stam <= 0) {
                    heal = 60;
                }
            } else if (lmsg == "menutim") {
                menutim = num;
            } else if (lmsg == "poisTO") {
                poisTO = num;
                poison = 1;
                if (num == 0) {
                    poison = 0;
                }
            } else if (lmsg == "dotTO") {
                dotTO = num;
                dot = 1;
                if (num == 0) {
                    dot = 0;
                }
            } else if (lmsg == "hot0TO") {
                hot0TO = num;
                hot0 = 1;
            } else if (lmsg == "hot1TO") {
                hot1TO = num;
                hot1 = 1;
            } else if (lmsg == "sotTO") {
                sotTO = num;
                sot = 1;
            } else if (lmsg == "reflectTO") {
                reflectTO = num;
            } else if (lmsg == "racialTO") {
                racialTO = num;
            } else if (lmsg == "live") {
                live = num;
            } else if (lmsg == "heal") {
                heal = num;
                hnum = 1;
                healcount = 0;
                recovery = 5;
                hnum = 1;
                if (stam <= 0) {
                    heal = 60;
                }
            }
            // else if(lmsg == "ticks"){ticks = num;}
            else if (lmsg == "parti") {
                parti = num;
            } else if (lmsg == "partia") {
                partia = num;
            } else if (lmsg == "partib") {
                partib = num;
            } else if (lmsg == "partic") {
                partic = num;
            } else if (lmsg == "partiw") {
                partiw = num;
            } else if (lmsg == "partip") {
                partip = num;
            } else if (lmsg == "partil") {
                partil = num;
            } else if (lmsg == "partiz") {
                partiz = num;
            } else if (lmsg == "retry") {
                retry = num;
            } else if (lmsg == "SBTO") {
                BTO = num;
            } else if (lmsg == "SBWD") {
                SBWD = num;
            } else if (lmsg == "buff0TO") {
                buff0TO = num;
            } else if (lmsg == "buff1TO") {
                buff1TO = num;
            } else if (lmsg == "armor0TO") {
                armor0TO = num;
            } else if (lmsg == "armor1TO") {
                armor1TO = num;
            } else if (lmsg == "guardTO") {
                guard = num;
            } //llSay(0, "inmune will time out in: " + (string)num);}
            else if (lmsg == "Jump_T") {
                Jump_T = num;
            } else if (lmsg == "tmpstamTO") {
                tmpstamTO = num;
            } else if (lmsg == "tmplifeTO") {
                tmplifeTO = num;
            } else if (lmsg == "tempStatTO") {
                tempStatTO = num;
            }
        } else if (id == "control" && num == 0) {
            if (lmsg == "Run") {
                ini();
                llSetTimerEvent(0.5);
                llResetTime();
                //llWhisper(0, "Timer encendido");
            }
            else if (lmsg == "Off") {
                llSetTimerEvent(0);
                ini();
                //llWhisper(0, "Timer Apagado");
            }
        }

        if (id == "onDamageReceived") {
            handleDamage(lmsg);
        }

        if (id == "userData") {
            storeUserData(lmsg);
        }
    }

    timer() {
        integer offset = 1;
        tcomp += 1;
        if (tcomp > 5) {
            time = llGetAndResetTime();
            integer synch = llRound(time) * 2;
            offset = (synch - tcomp) + 1;
            tcomp = 0;
            if (offset < 1) {
                offset = 1;
            }
            chkheight();
        }
        if (offecool > 0) {
            offecool -= offset;
            if (offecool <= 0) {
                offecool = 0;
                llMessageLinked(LINK_THIS, 0, "offe", "cools");
                llOwnerSay("Your offensive skills are ready.");
            }
        }
        if (suppcool > 0) {
            suppcool -= offset;
            if (suppcool <= 0) {
                suppcool = 0;
                llMessageLinked(LINK_THIS, 0, "supp", "cools");
                llOwnerSay("Your support skills are ready.");
            }
        }
        if (healcool > 0) {
            healcool -= offset;
            if (healcool <= 0) {
                healcool = 0;
                llMessageLinked(LINK_THIS, 0, "heal", "cools");
                llOwnerSay("Your healing skills are ready.");
            }
        }
        if (dazed > 0) {
            dazed -= offset;
            if (dazed <= 0) {
                dazed = 0;
                llMessageLinked(LINK_THIS, 0, "daze", "stats");
                llSay(0, owname + " is standing again.");
            }
        }

        if (silenced > 0) {
            silenced -= offset;
            if (silenced <= 0) {
                silenced = 0;
                llMessageLinked(LINK_THIS, 0, "silenced", "Skills");
                llSay(0, owname + " is no longer silenced.");
            }
        }

        if (cursed > 0) {
            cursed -= offset;
            if (cursed <= 0) {
                cursed = 0;
                llMessageLinked(LINK_THIS, 0, "curse", "stats");
                llSay(0, owname + " is no longer darn.");
            }
        }
        if (brskTO > 0) {
            brskTO -= offset;
            if (brskTO <= 0) {
                brskTO = 0;
                llMessageLinked(LINK_THIS, 0, "brsk_TO", "stats");
            }
        }
        if (weak > 0) {
            weak -= offset;
            if (weak <= 0) {
                weak = 0;
                llMessageLinked(LINK_THIS, 0, "weak", "stats");
                llSay(0, owname + " is no longer exhausted.");
            }
        }
        if (poison > 0) {
            poison += 1;
            if (poison >= 11) {
                poison = 1;
                llMessageLinked(LINK_THIS, 0, "POIS_Tick", "ctrl");
            }
        }
        if (poisTO > 0) {
            poisTO -= offset;
            if (poisTO <= 0) {
                poisTO = 0;
                poison = 0;
                llMessageLinked(LINK_THIS, 0, "poisTO", "ctrl");
            }
        }
        if (dot > 0) {
            dot += 1;
            if (dot >= 11) {
                dot = 1;
                llMessageLinked(LINK_THIS, 0, "DOT_Tick", "ctrl");
            }
        }
        if (dotTO > 0) {
            dotTO -= offset;
            if (dotTO <= 0) {
                dotTO = 0;
                dot = 0;
                llMessageLinked(LINK_THIS, 0, "dotTO", "ctrl");
            }
        }
        if (hot0TO > 0) {
            hot0TO -= offset;
            if (hot0TO <= 0) {
                hot0TO = 0;
                hot0 = 0;
                llMessageLinked(LINK_THIS, 0, "hot0TO", "ctrl");
            }
        }
        if (hot1TO > 0) {
            hot1TO -= offset;
            if (hot1TO <= 0) {
                hot1TO = 0;
                hot1 = 0;
                llMessageLinked(LINK_THIS, 0, "hot1TO", "ctrl");
            }
        }
        if (sotTO > 0) {
            sotTO -= offset;
            if (sotTO <= 0) {
                sotTO = 0;
                sot = 0;
                llMessageLinked(LINK_THIS, 0, "sotTO", "ctrl");
            }
        }
        if (hot0 > 0) {
            hot0 += 1;
            if (hot0 >= 9) {
                hot0 = 1;
                llMessageLinked(LINK_THIS, 0, "HOT0_Tick", "ctrl");
            }
        }
        if (hot1 > 0) {
            hot1 += 1;
            if (hot1 >= 9) {
                hot1 = 1;
                llMessageLinked(LINK_THIS, 0, "HOT1_Tick", "ctrl");
            }
        }
        if (sot > 0) {
            sot += 1;
            if (sot >= 9) {
                sot = 1;
                llMessageLinked(LINK_THIS, 0, "SOT_Tick", "ctrl");
            }
        }
        if (mtropen > 0) {
            mtropen -= offset;
            if (mtropen <= 0) {
                mtropen = 0;
                llMessageLinked(LINK_THIS, 0, "mtropen", "stats");
            }
        }
        if (menutim > 0) {
            menutim -= offset;
            if (menutim <= 0) {
                menutim = 0;
                llMessageLinked(LINK_THIS, 0, "menutim", "ctrl");
            }
        }
        // if (ticks > 0){ticks -= offset;if (ticks <= 0){ticks = (tickset * 2);
        //  llMessageLinked(LINK_THIS, 0, "ticks", "Control");}}
        if (live > 0) {
            live -= offset;
            if (live <= 0) {
                live = 0;
                llMessageLinked(LINK_THIS, 0, "live", "ctrl");
                healcount = 25;
                heal = 2;
                recovery = 1;
                hnum = 2;
                auto_heal();
            }
        }
        if (retry > 0) {
            retry -= offset;
            if (retry <= 0) {
                retry = 0;
                llMessageLinked(LINK_THIS, 0, "retry", "ctrl");
            }
        }
        if (BTO > 0) {
            BTO -= offset;
            if (BTO <= 0) {
                BTO = 0;
                llMessageLinked(LINK_THIS, 0, "CBTO", "NCS-MBoot");
            }
        }
        if (SBWD > 0) {
            SBWD -= offset;
            if (SBWD <= 0) {
                SBWD = 0;
                llMessageLinked(LINK_THIS, 0, "CSBWD", "NCS-MBoot");
            }
        }
        if (parti > 0) {
            parti -= offset;
            if (parti <= 0) {
                parti = 0;
                llMessageLinked(LINK_THIS, 0, "parti", "stime");
            }
        }
        if (partia > 0) {
            partia -= offset;
            if (partia <= 0) {
                partia = 0;
                llMessageLinked(LINK_THIS, 0, "partia", "stime");
            }
        }
        if (partib > 0) {
            partib -= offset;
            if (partib <= 0) {
                partib = 0;
                llMessageLinked(LINK_THIS, 0, "partib", "stime");
            }
        }
        if (partiw > 0) {
            partiw -= offset;
            if (partiw <= 0) {
                partiw = 0;
                llMessageLinked(LINK_THIS, 0, "partiw", "stime");
            }
        }
        if (partic > 0) {
            partic -= offset;
            if (partic <= 0) {
                partic = 0;
                llMessageLinked(LINK_THIS, 0, "partic", "stime");
            }
        }
        if (partip > 0) {
            partip -= offset;
            if (partip <= 0) {
                partip = 0;
                llMessageLinked(LINK_THIS, 0, "partip", "stime");
            }
        }
        if (partil > 0) {
            partil -= offset;
            if (partil <= 0) {
                partil = 0;
                llMessageLinked(LINK_THIS, 0, "partil", "stime");
            }
        }
        if (partiz > 0) {
            partiz -= offset;
            if (partiz <= 0) {
                partiz = 0;
                llMessageLinked(LINK_THIS, 0, "partiz", "stime");
            }
        }
        if (Jump_T > 0) {
            Jump_T -= offset;
            if (Jump_T <= 0) {
                Jump_T = 0;
                llMessageLinked(LINK_THIS, 0, "Jump_TO", "stime");
            }
        }
        if (buff0TO > 0) {
            buff0TO -= offset;
            if (buff0TO <= 0) {
                buff0TO = 0;
                llMessageLinked(LINK_THIS, 0, "buff0TO", "ctrl");
            }
        }
        if (buff1TO > 0) {
            buff1TO -= offset;
            if (buff1TO <= 0) {
                buff1TO = 0;
                llMessageLinked(LINK_THIS, 0, "buff1TO", "ctrl");
            }
        }
        if (armor0TO > 0) {
            armor0TO -= offset;
            if (armor0TO <= 0) {
                armor0TO = 0;
                llMessageLinked(LINK_THIS, 0, "armor0TO", "ctrl");
            }
        }

        if (armor1TO > 0) {
            armor1TO -= offset;
            if (armor1TO <= 0) {
                armor1TO = 0;
                llMessageLinked(LINK_THIS, 0, "armor1TO", "ctrl");
            }
        }

        if (tempStatTO > 0) {
            tempStatTO -= offset;
            if (tempStatTO <= 0) {
                tempStatTO = 0;
                llMessageLinked(LINK_THIS, 0, "tempStat", "ctrl");
            }
        }

        if (racialTO > 0) {
            racialTO -= offset;

            if (racialTO <= 0) {
                racialTO = 0;
                racialDamage = 0;
            }
        }

        if (guard > 0) {
            guard -= offset;
            if (guard <= 0) {
                guard = 0;
                llMessageLinked(LINK_THIS, 0, "guardTO", "ctrl");
            }
        }
        if (tmpstamTO > 0) {
            tmpstamTO -= offset;
            if (tmpstamTO <= 0) {
                tmpstamTO = 0;
                llMessageLinked(LINK_THIS, 0, "tmpstamTO", "ctrl");
            }
        }
        if (reflectTO > 0) {
            reflectTO -= offset;

            if (reflectTO <= 0) {
                reflectTO = 0;
                llMessageLinked(LINK_THIS, 0, "reflectTO", "ctrl");
            }
        }
        if (tmplifeTO > 0) {
            tmplifeTO -= offset;
            if (tmplifeTO <= 0) {
                tmplifeTO = 0;
                llMessageLinked(LINK_THIS, 0, "tmplifeTO", "ctrl");
            }
        }
        if (heal > 0) {
            heal -= offset;
            if (heal <= 0) {
                heal = (recovery * 2);
                auto_heal();
            }
        } //normal stam auto-heal
        //----------------------------------------------------------------------------------------------

        string mation = llGetAnimation(owner);
        if (mation == "Running" || mation == "Jumping") {
            llMessageLinked(LINK_THIS, 0, "runing", "ctrl");
        }
        //  else if(mation == "Jumping" && onair == 0|| mation == "PreJumping" || mation == "Landing")
        //   {llMessageLinked(LINK_THIS, 0, "OnTheAir", "ctrl");onair = 1;}else{onair = 0;
        //    llMessageLinked(LINK_THIS, 0, "NotOnTheAir", "ctrl");}
        // if(mation == "Crouching" || mation == "CrouchWalking" && block == 0)
        //  {llMessageLinked(LINK_THIS, 0, "block", "ctrl");block = 1;}
        // else if(mation == "Running" || mation == "Walking" || mation == "Standing" && block == 1)
        // {llMessageLinked(LINK_THIS, 0, "unblock", "ctrl");block = 0;}
        if (rezed == 1) {
            norez();
        }
    }
    changed(integer mask) {
        if (mask & CHANGED_OWNER) {
            llResetScript();
        }
    }
}