/*
* The familytree subsystem is supposed to be a way to
* assist RP by setting people up as related roundstart.
* This relation can be based on role (IE king and prince
* being father and son) or random chance.
*/
/*
* NOTES: There is some areas of this
* subsystem that can be more fleshed out
* such as how right now a house is just
* a bunch of names. Potentially this system
* can be used to create family curses/boons that
* effect all family members.
* There is also a additional variable i placed
* in human.dna called parent_mix that could be
* used for intrigue but currently it has
* no use and is only changed by the
* heritage datum BloodTies() proc.
*/
SUBSYSTEM_DEF(familytree)
	name = "familytree"
	flags = SS_NO_FIRE

	var/datum/heritage/ruling_family
	var/list/families = list()

/datum/controller/subsystem/familytree/Initialize()

	ruling_family = new /datum/heritage(null, null, "human")
	//Blank starter families that we can customize for players.
	families = list(
		new /datum/heritage(null, null, "human"),
		new /datum/heritage(null, null, "human"),
		new /datum/heritage(null, null, "elf"),
		new /datum/heritage(null, null, "elf"),
		new /datum/heritage(null, null, "dwarf"),
		new /datum/heritage(null, null, "dwarf"),
		new /datum/heritage(null, null, "tiefling"),
		new /datum/heritage(null, null, "tiefling"),
		)

	return ..()

/*
* In order for us to use age in sorting of generations we would need to
* make the king & queen older than the prince.
*/
/datum/controller/subsystem/familytree/proc/AddLocal(mob/living/carbon/human/H, status)
	if(!H || !status || istype(H, /mob/living/carbon/human/dummy))
		return
	//Exclude princes and princesses from having their parentage calculated.
	if(H.job == "Prince" || H.job == "Princess")
		return
	switch(status)
		if(FAMILY_PARTIAL)
			AssignToHouse(H)

		if(FAMILY_FULL)
			if(H.virginity)
				return
			AssignToFamily(H)

/*
* Assigns lord and lady to the royal family.
* If they are father or mother they claim the house in their name.
*/
/datum/controller/subsystem/familytree/proc/AddRoyal(mob/living/carbon/human/H, status)
	if(!ruling_family.housename && (status == FAMILY_FATHER || status == FAMILY_MOTHER))
		ruling_family.ClaimHouse(H)
		return
	ruling_family.addToHouse(H, status)

/*
* Assigns people randomly to one of the major
* famlies of Rockhill based on their species.
*/
/datum/controller/subsystem/familytree/proc/AssignToHouse(mob/living/carbon/human/H)
	//If no human and they are older than adult age.
	if(!H || H.age > AGE_ADULT)
		return
	var/species = H.dna.species.id
	var/adopted = FALSE
	var/datum/heritage/chosen_house
	var/list/low_priority_houses = list()
	var/list/high_priority_houses = list()
	for(var/datum/heritage/I in families)
		if(I.housename)
			high_priority_houses.Add(I)
		else
			low_priority_houses.Add(I)

	//Extremely sloppy but shorter code than writing the same code twice. -IP
	for(var/i = 1 to 2)
		var/list/what_we_checkin = high_priority_houses
		//If second run then check the other houses.
		if(i == 2)
			what_we_checkin = low_priority_houses
		for(var/datum/heritage/I in what_we_checkin)
			if(I.dominant_species == species)
				chosen_house = I
				break
			if(prob(7))
				chosen_house = I
				adopted = TRUE
				break
		if(chosen_house)
			break

	if(chosen_house)
		chosen_house.addToHouse(H, adopted ? FAMILY_ADOPTED : FAMILY_PROGENY)

/*
* Allows players to claim a
* house as patriarch or matriarch.
*/
/datum/controller/subsystem/familytree/proc/AssignToFamily(mob/living/carbon/human/H)
	if(!H)
		return
	var/species = H.dna.species.id
	var/list/low_priority_houses = list()
	var/list/high_priority_houses = list()
	for(var/datum/heritage/I in families)
		if((I.matriarch && I.patriarch) || I.dominant_species != species)
			continue
		if(I.family.len >= 1 && I.family.len < 5)
			high_priority_houses.Add(I)
		else
			low_priority_houses.Add(I)

	for(var/i = 1 to 2)
		var/list/what_we_checkin = high_priority_houses
		//If second run then check the other houses.
		if(i == 2)
			what_we_checkin = low_priority_houses
		for(var/datum/heritage/I in what_we_checkin)
			if(!I.housename)
				I.ClaimHouse(H)
				return
			if(!I.matriarch && H.gender == FEMALE)
				I.addToHouse(H, FAMILY_MOTHER)
				return
			if(!I.patriarch && H.gender == MALE)
				I.addToHouse(H, FAMILY_FATHER)
				return
