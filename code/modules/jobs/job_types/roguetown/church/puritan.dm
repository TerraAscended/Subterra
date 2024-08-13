/datum/job/roguetown/puritan
	title = "Puritan"
	flag = PURITAN
	department_flag = CHURCHMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = list(
		"Humen",
		"Aasimar"
	)
	allowed_sexes = list(MALE)

	tutorial = "The Priest is my shepard and I am their enforcer, I will do everything in my power to protect the church from evil and serve the priest at all costs. Should I capture evil they will confess their sins before the gods!"
	whitelist_req = FALSE

	outfit = /datum/outfit/job/roguetown/puritan
	display_order = JDO_PURITAN
	give_bank_account = 36
	min_pq = -4
	bypass_lastclass = TRUE

/datum/job/roguetown/puritan/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!L.mind)
		return
	if(L.mind.has_antag_datum(/datum/antagonist))
		return
	var/datum/antagonist/new_antag = new /datum/antagonist/purishep()
	L.mind.add_antag_datum(new_antag)

/datum/outfit/job/roguetown/puritan
	name = "Puritan"
	jobtype = /datum/job/roguetown/puritan

/datum/outfit/job/roguetown/puritan/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/psicross/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/tights/black
	cloak = /obj/item/clothing/cloak/cape/puritan
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	head = /obj/item/clothing/head/roguetown/puritan
	gloves = /obj/item/clothing/gloves/roguetown/leather
	beltl = /obj/item/rogueweapon/sword/rapier
	backpack_contents = list(/obj/item/keyring/puritan = 1)

	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.change_stat("intelligence", 3)
		H.change_stat("strength", 2)
		H.change_stat("perception", 3)
		if(H.mind.has_antag_datum(/datum/antagonist))
			return
		var/datum/antagonist/new_antag = new /datum/antagonist/purishep()
		H.mind.add_antag_datum(new_antag)

	if(!H.has_language(/datum/language/oldpsydonic))
		H.grant_language(/datum/language/oldpsydonic)
		to_chat(H, "<span class='info'>I can speak Old Psydonic with ,m before my speech.</span>")
	ADD_TRAIT(H, TRAIT_TORTURER, TRAIT_GENERIC)
	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim

/mob/living/carbon/human/proc/torture_victim()
	set name = "ExtractConfession"
	set category = "Inquisition"

	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	if(istype(I))
		if(ishuman(I.grabbed))
			H = I.grabbed
			if(H == src)
				to_chat(src, "<span class='warning'>I already torture myself.</span>")
				return
			var/painpercent = H.get_complex_pain() / (H.STAEND * 10)
			painpercent = painpercent * 100
			var/mob/living/carbon/C = H
			if(C.add_stress(/datum/stressevent/tortured))
				if(!H.stat)
					say(pick("CONFESS!",
								"TELL ME YOUR SECRETS!",
								"SPEAK!",
								"YOU WILL SPEAK!",
								"TELL ME!",
								"THE PAIN HAS ONLY BEGUN, CONFESS!"), spans = list("torture"))
					if((painpercent > 90) || (!H.cmode))
						H.emote("painscream")
						H.confession_time()
						return
			to_chat(src, "<span class='warning'>Not ready to speak yet.</span>")

/mob/living/carbon/human/proc/confession_time()
	var/timerid = addtimer(CALLBACK(src, PROC_REF(confess_sins)), 6 SECONDS, TIMER_STOPPABLE)
	var/responsey = alert("Resist torture? (1 TRI)","Yes","No")
	if(!responsey)
		responsey = "No"
	if(SStimer.timer_id_dict[timerid])
		deltimer(timerid)
	else
		to_chat(src, "<span class='warning'>Too late...</span>")
		return
	if(responsey == "Yes")
		adjust_triumphs(-1)
		confess_sins(TRUE)
	else
		confess_sins()

/mob/living/carbon/human/proc/confess_sins(resist)
	if(!resist)
		var/list/confessions = list()
		for(var/datum/antagonist/antag in mind?.antag_datums)
			if(length(antag.confess_lines))
				confessions += antag.confess_lines
		if(length(patron.confess_lines))
			confessions += patron.confess_lines
		if(length(confessions))
			say(pick(confessions), spans = list("torture"))
			return

	var/static/list/innocent_lines = list(
		"I DON'T KNOW!",
		"STOP THE PAIN!!",
		"I DON'T DESERVE THIS!",
		"THE PAIN!",
		"I HAVE NOTHING TO SAY...!",
		"WHY ME?!",
	)
	say(pick(innocent_lines), spans = list("torture"))


/mob/living/carbon/human/proc/faith_test()
	set name = "FaithTest"
	set category = "Inquisition"
	set hidden = 1
	//same as above, but CRY TO YOUR GOD! BEG TO YOUR CREATOR! WHO DO YOU WORSHIP? WHO IS YOUR MASTER?
