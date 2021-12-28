key owner;
key self;
key dragger;
float RADIUS = 15.0;
float FORCE = 50;
list swatos;
integer blow;
float hitrate = 0.25;
integer effect = 0;
integer dazed;
integer blocking;
integer nocomb;
integer onair;
integer brsk;
integer prim = 9;
integer pflags = 267;
integer patern = 2;
integer partcount = 2;
vector sscale = <0.2, 0.2, 0>;
vector escale = <0.4, 0.4, 0>;
vector scolor = <0.91941, 0.01941, 0.01941>;
vector ecolor = <1.00000, 0.10000, 0.20000>;
vector omega = <0.0, 0.0, 0.0>;
vector accel = <-0.0, -0.0, 3.0>;
float sglow = 0.00;
float eglow = 0.0;
float angleb = 0.0;
float anglee = 0.0;
float agemax = 2;
float brate = 0.5;
float mabspeed = 0;
float mibspeed = -8;
float salpha = 1.000000;
float ealpha = 0.200000;
string texture =  "ee99d234-d9b3-99c0-0e8c-08d65fe86a4b";
string htexture = "ee99d234-d9b3-99c0-0e8c-08d65fe86a4b";
string btexture = "a5b2eff4-dfb5-c85c-bc52-9bd9f1a8dce7";
string wtexture = "90c53b22-3df0-76b7-112b-0dd417f09844";
string ctexture = "90c53b22-3df0-76b7-112b-0dd417f09844";
string atexture = "b2999ef4-b354-7e6b-35db-e6e9a10302da";
string ptexture = "87e993af-8a6a-224f-bbf8-cbfeed9f2256";
string ltexture = "b3d92ef6-1f39-e96a-0083-ab244515a18b";// arrows level up
string ztexture = "6844d88e-5acd-061d-1ccd-5fd771f9383b"; // Zombie live texture

// LINKSET: Top out = 3, Top mid = 4, Top in = 5, Head out = 1, Head mid = 2, Chest out = 6, Chest mid = 7, Chest in = 8, Feet out = 9, Feet mid = 10, Feet in = 11

Auraparts()
{
llLinkParticleSystem(prim,[
    PSYS_PART_FLAGS, PSYS_PART_BOUNCE_MASK | PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK,
    PSYS_SRC_TEXTURE, texture,
    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
    PSYS_PART_START_COLOR, <0.1,0.2,0.8>,
    PSYS_PART_START_ALPHA, 0.9,
    PSYS_PART_END_ALPHA, 0.2,
    PSYS_PART_END_COLOR, <0.1,0.3,1.0>,
    PSYS_PART_START_SCALE, <0.45,0.45,0.45>,
    PSYS_PART_END_SCALE, <0.03,0.25,0.1>,
    PSYS_SRC_BURST_PART_COUNT, 150,
    PSYS_PART_MAX_AGE, 2.0,
    PSYS_SRC_BURST_RATE, 0.05,
    PSYS_SRC_ACCEL, <0.0, 0.0, 4.98>,
    PSYS_SRC_BURST_SPEED_MIN, -10.0,
    PSYS_SRC_BURST_SPEED_MAX, 0.0,
    PSYS_SRC_OMEGA, <0.0, 0.0, 1.0>,
    PSYS_SRC_BURST_RADIUS, 1.0,
    PSYS_SRC_ANGLE_BEGIN, PI/2 - 0.01,
    PSYS_SRC_ANGLE_END, PI/2]);
    if(prim == 10){llMessageLinked(LINK_THIS, 15, "partil", "timer");}
}

particulas()
{
    llLinkParticleSystem(prim,[
        PSYS_PART_MAX_AGE, agemax,
        PSYS_PART_FLAGS,pflags,
        PSYS_PART_FOLLOW_SRC_MASK,0,
        PSYS_PART_START_COLOR, scolor,
        PSYS_PART_END_COLOR, ecolor,
        PSYS_PART_START_SCALE, sscale,
        PSYS_PART_END_SCALE, escale,
        PSYS_SRC_PATTERN,patern,
        PSYS_PART_START_GLOW, sglow,
        PSYS_PART_END_GLOW, eglow,
        PSYS_SRC_BURST_RATE,brate,
        PSYS_SRC_ACCEL,accel,
        PSYS_SRC_BURST_PART_COUNT,partcount,
        PSYS_SRC_BURST_RADIUS,0.5,
        PSYS_SRC_BURST_SPEED_MIN,mibspeed,
        PSYS_SRC_BURST_SPEED_MAX,mabspeed,
        PSYS_SRC_MAX_AGE,0.000000,
        PSYS_SRC_OMEGA, omega,
        PSYS_SRC_ANGLE_BEGIN,angleb,
        PSYS_SRC_ANGLE_END,anglee,
        PSYS_PART_START_ALPHA,salpha,
        PSYS_PART_END_ALPHA,ealpha,
        PSYS_SRC_TEXTURE, texture,
        PSYS_SRC_TARGET_KEY,owner]);
        if(prim == 1){llMessageLinked(LINK_THIS, 3, "partiw", "timer");}
        else if(prim == 2){llMessageLinked(LINK_THIS, 3, "partic", "timer");}
        else if(prim == 3){llMessageLinked(LINK_THIS, 3, "partiz", "timer");}
        else if(prim == 6){llMessageLinked(LINK_THIS, 3, "partib", "timer");}
        else if(prim == 7){llMessageLinked(LINK_THIS, 3, "partia", "timer");}
        else if(prim == 8){llMessageLinked(LINK_THIS, 10, "partip", "timer");}
        else if(prim == 9){llMessageLinked(LINK_THIS, 5, "parti", "timer");}
        else if(prim == 10){llMessageLinked(LINK_THIS, 15, "partil", "timer");}
}
stop_parts()
{
    llLinkParticleSystem(prim,[
        PSYS_PART_MAX_AGE, 0,
        PSYS_PART_FLAGS,0,
        PSYS_PART_FOLLOW_SRC_MASK,0,
        PSYS_PART_START_COLOR, <0.0, 0.0, 0.0>,
        PSYS_PART_END_COLOR, <0.00000, 0.00000, 0.00000>,
        PSYS_PART_START_SCALE, <0, 0, 0>,
        PSYS_PART_END_SCALE, <0, 0, 0>,
        PSYS_SRC_PATTERN,2,
        PSYS_PART_START_GLOW, 0.00,
        PSYS_PART_END_GLOW, 0.00,
        PSYS_SRC_BURST_RATE,0.1,
        PSYS_SRC_ACCEL,<0, 0, 0>,
        PSYS_SRC_BURST_PART_COUNT,0,
        PSYS_SRC_BURST_RADIUS,0,
        PSYS_SRC_BURST_SPEED_MIN,0,
        PSYS_SRC_BURST_SPEED_MAX,0,
        PSYS_SRC_INNERANGLE,0,
        PSYS_SRC_OUTERANGLE,0,
        PSYS_SRC_MAX_AGE,0.000000,
        PSYS_PART_START_ALPHA,0.000000,
        PSYS_PART_END_ALPHA,0.000000,
        PSYS_SRC_TEXTURE, texture,
        PSYS_SRC_TARGET_KEY,owner ]);
}
scan()
{
    llSensor("", dragger, AGENT_BY_LEGACY_NAME, RADIUS, PI);
}
draggedby()
{

       // target_id = llTarget(pos, 0.5);
        llSensor("", dragger, AGENT_BY_LEGACY_NAME, RADIUS, PI);
        vector pos = llDetectedPos(0);vector offset =<2.5,0,0>;pos+=offset;
        llMoveToTarget(pos,1.5);llSleep(hitrate);llStopMoveToTarget();
        scan();
}
moveto()
{
        ;vector pos = llDetectedPos(0);vector offset =<0,0,0>;pos+=offset;
        llMoveToTarget(pos,0.1);llSleep(hitrate);llStopMoveToTarget();
}
attract()
{
    if(brsk == 1)
    {
        integer swatlistlen = llGetListLength(swatos);
        integer j;
        for (j = 0; j < swatlistlen; j += 3)
            {
            key target_key = llList2Key(swatos, j);
            integer k;
            for (k = 0; k < 1; k ++)
                {
            vector target_pos = llList2Vector(swatos, (j + 1));// the position of our target
            vector offset =<0,0,0>;target_pos+=offset;
            vector my_pos = llGetPos();
            // normalized vector describing the direction
            // from our target to us
            // this is a negative vector
            // which will draw the object towards us
            vector direction = llVecNorm(my_pos - target_pos);
            // apply set amount of force
            // in the direction from the target to this object
            vector impulse = FORCE * direction;
            // equalize for the targets mass so pull is consistent
            impulse *= llGetObjectMass(target_key);
            // equalize for the distance of the target
            // so pull is consistent
            impulse *= llPow(llVecDist(my_pos, target_pos), 6.0);
            // negate the targets current velocity
            impulse -= llList2Vector(swatos, (j + 2));
            llPushObject(target_key, impulse, llGetLocalPos(), FALSE);
            llMoveToTarget(target_pos,0.1);llSleep(hitrate);llStopMoveToTarget();//llSleep(0.05);
           // llOwnerSay(llKey2Name(target_key) + ", " + (string)target_pos);
                }
            }
                llSensor("", "", AGENT_BY_LEGACY_NAME, RADIUS, PI);
        }
}
take()
{
        llStopAnimation("NCS-Stuned");dazed = 0;llSensorRemove();llStopMoveToTarget();brsk = 0;
        llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD |
        CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT |
        CONTROL_DOWN, TRUE, TRUE);
}
ini()
{
    owner = llGetOwner();
    self = llGetKey();brsk = 0;blow = 0;dragger = "";
    llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
    llSetLinkPrimitiveParamsFast(1, [PRIM_TEXTURE, ALL_SIDES, wtexture, <1.0, 1.0, 0.0>, <1.0, 1.0, 0.0>, 0.0]); // weak
    llSetLinkPrimitiveParamsFast(2, [PRIM_TEXTURE, ALL_SIDES, ctexture, <1.0, 1.0, 0.0>, <1.0, 1.0, 0.0>, 0.0]); // course
    llSetLinkPrimitiveParamsFast(3, [PRIM_TEXTURE, ALL_SIDES, ztexture, <1.0, 1.0, 0.0>, <1.0, 1.0, 0.0>, 0.0]); // zombie
    llSetLinkPrimitiveParamsFast(6, [PRIM_TEXTURE, ALL_SIDES, btexture, <1.0, 1.0, 0.0>, <1.0, 1.0, 0.0>, 0.0]); // buff
    llSetLinkPrimitiveParamsFast(7, [PRIM_TEXTURE, ALL_SIDES, atexture, <1.0, 1.0, 0.0>, <1.0, 1.0, 0.0>, 0.0]); // armor
    llSetLinkPrimitiveParamsFast(8, [PRIM_TEXTURE, ALL_SIDES, ptexture, <1.0, 1.0, 0.0>, <1.0, 1.0, 0.0>, 0.0]); // poison
    llSetLinkPrimitiveParamsFast(9, [PRIM_TEXTURE, ALL_SIDES, htexture, <1.0, 1.0, 0.0>, <1.0, 1.0, 0.0>, 0.0]); // healing
    llSetLinkPrimitiveParamsFast(10, [PRIM_TEXTURE, ALL_SIDES, ltexture, <1.0, 1.0, 0.0>, <1.0, 1.0, 0.0>, 0.0]); // level up
    onair = 0;llLinkParticleSystem(LINK_SET,[]);
}
default
{
    state_entry()
    {
        ini();
    }
    run_time_permissions(integer perms)
    {
        if(perms & PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD |
CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT |
CONTROL_DOWN, TRUE, TRUE);
        }
        if(perms & PERMISSION_TRIGGER_ANIMATION)
        {
            llStopAnimation("NCS-Stuned");llStopAnimation("Blocking1");llStopAnimation("block_daz");
            llStopAnimation("NCS-Defeated");llStartAnimation("express_anger_emote");brsk = 0;
            llSensorRemove();
        }
    }
    attach(key attached)
    {
        if(attached != NULL_KEY)
        {
            ini();
        }
        else
        {

        }
    }
    collision_start(integer total)
    {
        key collided = llDetectedKey(0);//llSay(0, "Colision con: " + llKey2Name(collided));
            if(llDetectedType(0) & AGENT_BY_LEGACY_NAME)
            {
               if(brsk == 1)
               {
                string victim = (string)llDetectedKey(0);llMessageLinked(LINK_THIS, effect, "Mele", victim);
                moveto();
                }
                else if(dragger != ""){llMessageLinked(LINK_THIS, 0, "Dragg", "ctrl");}
            }
    }
    collision_end(integer tota_num)
    {
        key collided = llDetectedKey(0);//llSay(0, "Colision con: " + llKey2Name(collided));
            if(llDetectedType(0) & AGENT_BY_LEGACY_NAME)
            {
               llStopMoveToTarget();
            }

    }
    sensor(integer total)
    {
        if(dazed == 1 && dragger != ""){draggedby();}
        else if(dazed == 0 && blocking  == 0 && blow == 1){blow = 0;
        integer i;
        for(i = 0; i < total; i++)
        {string victim = (string)llDetectedKey(i);llMessageLinked(LINK_THIS, effect, "Mele", victim);}
        llSleep(hitrate);}
        else if(brsk == 1)
            {
                 key Bdet;
                vector swatvel;
                vector swatpos;
                swatos = [];
                integer i;
            for (i = 0; i < total; i ++)
                {
                    Bdet = llDetectedKey(i);
                    swatpos = llDetectedPos(i);
                    swatvel = llDetectedVel(i);
                    swatos += [Bdet] + [swatpos] + [swatvel];
                }
          attract();
            }
    }
    control(key id,integer held,integer change)
    {
        if(held & CONTROL_LBUTTON || held & CONTROL_ML_LBUTTON)
        {
            if((change & held & CONTROL_ROT_LEFT) | (change & ~held & CONTROL_LEFT))
            {blow = 1;}
            else if((change & held & CONTROL_ROT_RIGHT) | (change & ~held & CONTROL_RIGHT))
            {blow = 1;}
            else if(change & held & CONTROL_FWD)
            {blow = 1;}
            else if(change & held & CONTROL_BACK)
            {blow = 1;}
            else if(change & CONTROL_DOWN && blocking  == 0)
            {llMessageLinked(LINK_THIS, 0, "block", "ctrl");}//llStartAnimation("Blocking1");}
            else if(change & CONTROL_DOWN && blocking  == 1)
            {llMessageLinked(LINK_THIS, 0, "unblock", "ctrl");}
            else if(change & CONTROL_UP)
            {llMessageLinked(LINK_THIS, 0, "unblock", "ctrl");}
            if(blow == 1){llSensor("", "", (ACTIVE|AGENT), 2.5, PI/4);}
        }
       else if(change & CONTROL_DOWN && blocking  == 0)
       {llMessageLinked(LINK_THIS, 0, "block", "ctrl");}//llStartAnimation("Blocking1");}
       else if(change & CONTROL_UP)
       {llMessageLinked(LINK_THIS, 0, "unblock", "ctrl");}//llStartAnimation("Blocking1");}
       else if(change & CONTROL_DOWN && blocking  == 1)
       {llMessageLinked(LINK_THIS, 0, "unblock", "ctrl");}
       if(onair == 0){if( change & CONTROL_UP)
       {llMessageLinked(LINK_THIS, 0, "jumping", "ctrl");
       llMessageLinked(LINK_THIS, 2, "Jump_T", "timer");onair  = 1;}}
    }
    link_message(integer sender, integer num, string lmsg, key id)
    {
        //llOwnerSay("Sender: " + (string)sender + ", Num: " + (string)num + ", Mess: " + lmsg + ", ID: " + (string)id);
        if(id == "controls" && num == 0)
        {
            if(lmsg == "dead"){llStartAnimation("NCS-Defeated");llStopAnimation("Blocking1");llStopAnimation("block_daz");take();}
            else if(lmsg == "live"){llStopAnimation("NCS-Defeated");llStopAnimation("Blocking1");llStopAnimation("block_daz");take();}
            //-----------------------------------------------------------------------------------------------------------
            else if(lmsg == "Zomb_live"){llStartAnimation("NCS-Zombie-Live1");prim = 3;agemax = 8;pflags = 339;scolor = <0.70000, 0.00000, 0.00000>;
            ecolor = <1.00000, 1.00000, 1.00000>;sscale = <0.15000, 0.15000, 0.00000>;escale = <0.50000, 0.50000, 0.00000>;
            patern = 4;sglow = 0.00;eglow = 0.0;accel = <0.0, 0.0, 0.0>;partcount = 5;omega = <0.00000, 0.00000, 5.50000>;
            mabspeed = 1.500000;mibspeed = 1.500000;brate = 0.025000;salpha = 1.000000;ealpha = 0.000000;
            angleb = 0.500000*PI;anglee = 0.500000*PI;texture = ztexture;particulas();}
            //-----------------------------------------------------------------------------------------------------------
            else if(lmsg == "faid"){prim = 9;agemax = 2;pflags = 267;scolor = <0.91941, 0.91941, 0.91941>;
            ecolor = <1.00000, 1.00000, 1.00000>;sscale = <0.2, 0.2, 0>;escale = <0.2, 0.2, 0>;
            patern = 2;sglow = 0.00;eglow = 0.0;accel = <0.0, 0.0, 3.0>;partcount = 1;
            mabspeed = 0;mibspeed = -8;brate = 0.04;salpha = 1.000000;ealpha = 0.200000;texture = htexture;particulas();}
            //-----------------------------------------------------------------------------------------------------------
            else if(lmsg == "bffd"){prim = 6;agemax = 0.5;pflags = 275;scolor = <0.91941, 0.91941, 0.91941>;
            ecolor = <1.00000, 1.00000, 1.00000>;sscale = <1.25, 1.25, 0>;escale = <0.2, 0.2, 0>;
            patern = 5;sglow = 0.01;eglow = 0.1;accel = <0.0, 0.0, 0.0>;partcount = 1;
            mabspeed = 1;mibspeed = 1;brate = 0.08;salpha = 0.30000;ealpha = 0.559900;texture = btexture;particulas();}
            //-----------------------------------------------------------------------------------------------------------
            else if(lmsg == "armr"){prim = 7;agemax = 0.5;pflags = 275;scolor = <0.91941, 0.91941, 0.91941>;
            ecolor = <1.00000, 1.00000, 1.00000>;sscale = <1.25, 1.25, 0>;escale = <0.2, 0.2, 0>;
            patern = 5;sglow = 0.01;eglow = 0.1;accel = <0.0, 0.0, 0.0>;partcount = 1;
            mabspeed = 1;mibspeed = 1;brate = 0.08;salpha = 0.30000;ealpha = 0.559900;texture = atexture;particulas();}
            //-----------------------------------------------------------------------------------------------------------
            else if(lmsg == "weakn"){prim = 1;agemax = 3;pflags = 275;scolor = <0.91941, 0.01941, 0.01941>;
            ecolor = <1.00000, 0.10000, 0.20000>;sscale = <1.5, 1.5, 0>;escale = <0.3, 0.3, 3>;
            patern = 1;sglow = 0.01;eglow = 0.05;accel = <0.0, 0.0, -0.15>;partcount = 1;
            mabspeed = 1;mibspeed = 1;brate = 0.05;salpha = 0.20000;ealpha = 0.550000;texture = wtexture;particulas();
            }//llStartAnimation("weak-hit2");
            //-----------------------------------------------------------------------------------------------------------
            else if(lmsg == "cursd"){prim = 2;agemax = 3;pflags = 275;scolor = <0.91941, 0.91941, 0.91941>;
            ecolor = <1.00000, 1.00000, 1.00000>;sscale = <1.5, 1.5, 0>;escale = <0.4, 0.4, 0>;
            patern = 1;sglow = 0.01;eglow = 0.05;accel = <0.0, -0.0, 0.0>;partcount = 1;
            mabspeed = 1;mibspeed = 1;brate = 0.05;salpha = 0.20000;ealpha = 0.990000;texture = ctexture;particulas();
            llStartAnimation("Got-Cursed");}
            //-----------------------------------------------------------------------------------------------------------
            else if(lmsg == "poisond"){prim = 8;agemax = 3;pflags = 275;scolor = <0.01941, 0.91941, 0.01941>;
            ecolor = <0.10000, 1.00000, 0.20000>;sscale = <1.25, 1.25, 0>;escale = <1.50, 1.50, 0>;
            patern = 5;sglow = 0.01;eglow = 0.05;accel = <0.0, 0.0, 0.0>;partcount = 1;
            mabspeed = 1;mibspeed = 1;brate = 0.05;salpha = 0.120000;ealpha = 0.160000;texture = ptexture;particulas();}
            //-----------------------------------------------------------------------------------------------------------
            else if(lmsg == "leveledup"){prim = 10;texture = ltexture;Auraparts();}
            //-----------------------------------------------------------------------------------------------------------
            else if(lmsg == "course"){llStartAnimation("Course");}
            else if(lmsg == "hoverf"){llStartAnimation("NCS-Hover-F1");}
            else if(lmsg == "hoverm"){llStartAnimation("NCS-Lvlup-M");}
        }
        else if(id == "ctrl" && num == 0)
        {if(lmsg == "block"){blocking = 1;if(dazed == 0)
        {llStartAnimation("Blocking1");}else{llStartAnimation("block_daz");}}
        else if(lmsg == "unblock"){blocking = 0;
        llStopAnimation("Blocking1");llStopAnimation("block_daz");}
        else if(lmsg == "kos"){llStartAnimation("KO_Sign");}
        else if(lmsg == "Lvup"){llStartAnimation("NCS-LVUP-Hover-F1");}
        else if(lmsg == "LvupM"){llStartAnimation("NCS-LVUP-Hover-M");}}
        else if(id == "stime" && num == 0){
        if(lmsg == "parti"){prim = 9;texture = htexture;stop_parts();}
        else if(lmsg == "partib"){prim = 6;texture = btexture;stop_parts();}
        else if(lmsg == "partia"){prim = 7;texture = btexture;stop_parts();}
        else if(lmsg == "partiw"){prim = 1;texture = wtexture;stop_parts();}
        else if(lmsg == "partic"){prim = 2;texture = ctexture;stop_parts();}
        else if(lmsg == "partiz"){prim = 3;texture = ztexture;stop_parts();}
        else if(lmsg == "partip"){prim = 8;texture = ptexture;stop_parts();}
        else if(lmsg == "partil"){prim = 10;texture = ltexture;stop_parts();
        llStopAnimation("NCS-Lvlup-M");llStopAnimation("NCS-Hover-F1");}
        else if(lmsg == "Jump_TO"){onair = 0;}}
        else if(id == "timer")
        {
            if(lmsg == "dazed"){llStartAnimation("NCS-Stuned");dazed = 1;
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD |
            CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT |
            CONTROL_DOWN, TRUE, FALSE);}
        }
        else if(num == 31 && lmsg == "drag"){dragger = (key)id;draggedby();}//llOwnerSay("Effect: " + (string)num + "Base: "
        //+ lmsg + "ID: " + (string)id);}
        else if(id == "stats")
        {
            if(lmsg == "daze"){dragger = "";take();}
        }
        else if(id == "Hitrate"){hitrate = 1 - ((float)lmsg * 0.75);}
        else if(id == "contfx")
            {
            if(lmsg == "GotBrsk")
                {
                    RADIUS = num;brsk = 1;llSetStatus(STATUS_PHANTOM, FALSE);//llOwnerSay("Got-Brsk << From Game Script");
                    llSensor("", "", AGENT_BY_LEGACY_NAME, RADIUS, PI);
                }
            else if(lmsg == "GetUNBrsk")
                {
                    //llOwnerSay("BRSK - Stopped");
                   brsk = 0;llSensorRemove();llSay(0, llKey2Name(owner) + " regain sanity");
                }
            }
    }
    changed(integer mask)
    {
        if(mask & CHANGED_OWNER){llResetScript();}
    }
}