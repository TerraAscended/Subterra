//shield flail or longsword, tief can be this with red cross

/datum/advclass/combat/templar
	name = "Paladin"
	tutorial = "Paladins are former noblemen and clerics who have dedicated themselves to great combat prowess. Often, they were promised redemption for past sins if they crusaded in the name of the gods."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		"Humen",
		"Aasimar"
	)
	outfit = /datum/outfit/job/roguetown/adventurer/templar
	maximum_possible_slots = 1
	min_pq = 2
	pickprob = 15
	category_tags = list(CTAG_ADVENTURER)

/datum/outfit/job/roguetown/adventurer/templar/pre_equip(mob/living/carbon/human/H)
	..()
	H.virginity = TRUE

	switch(H.patron?.name)
		if("Astrata")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
			wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
		if("Dendor")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
			wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
		if("Necra")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/necrahelm
			wrists = /obj/item/clothing/neck/roguetown/psicross/necra
		if("Eora")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket // Placeholder?
			wrists = /obj/item/clothing/neck/roguetown/psicross/eora
		if("Noc")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
			wrists = /obj/item/clothing/neck/roguetown/psicross/noc
		else // Failsafe
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
			wrists = /obj/item/clothing/neck/roguetown/psicross/silver

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/hand
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/clothing/ring/silver
	cloak = /obj/item/clothing/cloak/tabard/crusader
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	gloves = /obj/item/clothing/gloves/roguetown/chain
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		backl = /obj/item/rogueweapon/sword/long/judgement
		H.change_stat("strength", 2)
		H.change_stat("perception", 2)
		H.change_stat("intelligence", 2)
		H.change_stat("constitution", 1)
		H.change_stat("endurance", 1)
		H.change_stat("speed", -2)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/churn)
	if(H.dna?.species)
		if(H.dna.species.id == "human")
			H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	var/datum/devotion/cleric_holder/C = new /datum/devotion/cleric_holder(H, H.patron)
	//Paladins, while devout warriors spent WAY too much time studying the blade. No more acolyte+
	C.update_devotion(50, 50)
	C.holder_mob = H
	C.grant_spells_templar(H)
	H.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/churn)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
