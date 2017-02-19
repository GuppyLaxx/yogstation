/obj/machinery/computer
	name = "computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300
	obj_integrity = 200
	max_integrity = 200
	integrity_failure = 100
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0, fire = 40, acid = 20)
	var/obj/item/weapon/circuitboard/computer/circuit = null // if circuit==null, computer can't disassembly
	var/processing = 0
	var/brightness_on = 2
	var/icon_keyboard = "generic_key"
	var/icon_screen = "generic"
	var/clockwork = FALSE
	paiAllowed = 1

/obj/machinery/computer/New(location, obj/item/weapon/circuitboard/C)
	..(location)
	if(C && istype(C))
		circuit = C
	//Some machines, oldcode arcades mostly, new themselves, so circuit
	//can already be an instance of a type and trying to new that will
	//cause a runtime
	else if(ispath(circuit))
		circuit = new circuit(null)
	power_change()
	update_icon()

/obj/machinery/computer/Destroy()
	if(circuit)
		qdel(circuit)
		circuit = null
	return ..()

/obj/machinery/computer/initialize()
	power_change()

/obj/machinery/computer/process()
	if(stat & (NOPOWER|BROKEN))
		return 0
	if(software)
		for(var/V in software)
			var/datum/software/M = V
			M.onMachineTick()
	return 1

/obj/machinery/computer/ratvar_act()
	if(!clockwork)
		clockwork = TRUE
		icon_screen = "ratvar[rand(1, 4)]"
		icon_keyboard = "ratvar_key[rand(1, 6)]"
		icon_state = "ratvarcomputer[rand(1, 4)]"
		update_icon()

/obj/machinery/computer/narsie_act()
	if(clockwork && clockwork != initial(clockwork) && prob(20)) //if it's clockwork but isn't normally clockwork
		clockwork = FALSE
		icon_screen = initial(icon_screen)
		icon_keyboard = initial(icon_keyboard)
		icon_state = initial(icon_state)
		update_icon()

/obj/machinery/computer/update_icon()
	cut_overlays()
	if(stat & NOPOWER)
		add_overlay("[icon_keyboard]_off")
		return
	add_overlay(icon_keyboard)
	if(stat & BROKEN)
		add_overlay("[icon_state]_broken")
	else
<<<<<<< HEAD
		overlays += icon_screen
	if(paired)
		overlays += "paipaired"
=======
		add_overlay(icon_screen)
>>>>>>> masterTGbranch

/obj/machinery/computer/power_change()
	..()
	if(stat & NOPOWER)
		SetLuminosity(0)
	else
		SetLuminosity(brightness_on)
	update_icon()
	return

/obj/machinery/computer/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver) && circuit && !(flags&NODECONSTRUCT))
<<<<<<< HEAD
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		user << "<span class='notice'>You start to disconnect the monitor...</span>"
		if(do_after(user, 20/I.toolspeed, target = src))
			deconstruction()
			var/obj/structure/frame/computer/A = new /obj/structure/frame/computer(src.loc)
			A.circuit = circuit
			A.anchored = 1
			circuit = null
			erase_data()
			for (var/obj/C in src)
				C.loc = src.loc
			if (stat & BROKEN)
				user << "<span class='notice'>The broken glass falls out.</span>"
=======
		playsound(src.loc, I.usesound, 50, 1)
		user << "<span class='notice'> You start to disconnect the monitor...</span>"
		if(do_after(user, 20*I.toolspeed, target = src))
			deconstruct(TRUE, user)
	else
		return ..()

/obj/machinery/computer/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(stat & BROKEN)
				playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
			else
				playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		if(BURN)
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)

/obj/machinery/computer/obj_break(damage_flag)
	if(circuit && !(flags & NODECONSTRUCT)) //no circuit, no breaking
		if(!(stat & BROKEN))
			playsound(loc, 'sound/effects/Glassbr3.ogg', 100, 1)
			stat |= BROKEN
			update_icon()

/obj/machinery/computer/emp_act(severity)
	switch(severity)
		if(1)
			if(prob(50))
				obj_break("energy")
		if(2)
			if(prob(10))
				obj_break("energy")
	..()

/obj/machinery/computer/deconstruct(disassembled = TRUE, mob/user)
	on_deconstruction()
	if(!(flags & NODECONSTRUCT))
		if(circuit) //no circuit, no computer frame
			var/obj/structure/frame/computer/A = new /obj/structure/frame/computer(src.loc)
			A.circuit = circuit
			A.anchored = 1
			if(stat & BROKEN)
				if(user)
					user << "<span class='notice'>The broken glass falls out.</span>"
				else
					playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
>>>>>>> masterTGbranch
				new /obj/item/weapon/shard(src.loc)
				new /obj/item/weapon/shard(src.loc)
				A.state = 3
				A.icon_state = "3"
			else
				if(user)
					user << "<span class='notice'>You disconnect the monitor.</span>"
				A.state = 4
				A.icon_state = "4"
			circuit = null
		for(var/obj/C in src)
			C.forceMove(loc)

<<<<<<< HEAD
/obj/machinery/computer/take_damage(damage, damage_type = BRUTE, sound_effect = 1)
	switch(damage_type)
		if(BRUTE)
			if(sound_effect)
				if(stat & BROKEN)
					playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
				else
					playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		if(BURN)
			if(sound_effect)
				playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
		else
			return
	computer_health = max(computer_health - damage, 0)
	if(circuit) //no circuit, no breaking
		if(!computer_health && !(stat & BROKEN))
			playsound(loc, 'sound/effects/Glassbr3.ogg', 100, 1)
			if(paired)
				paired.unpair(0)
			stat |= BROKEN
			update_icon()

/obj/machinery/computer/proc/erase_data()
	return 0
=======
	qdel(src)
>>>>>>> masterTGbranch
