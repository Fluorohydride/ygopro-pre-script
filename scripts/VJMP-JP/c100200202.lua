--Junk Mail Script
--Scripted by: CVen00/ToonyBirb with some code provided by XGlitchy30 via their tutorials and by looking at scripts for various other cards as outlined below.
local s,id=GetID()
function s.initial_effect(c)
	--effect 1: When used as synchro material, the monster cannot be destroyed by battle
	--used c50793215 for reference for Set methods
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)	--affects a single card and does not start a chain
	e1:SetCode(EVENT_BE_MATERIAL)	--make it only take effect when this card is used as material
	e1:SetCondition(s.condition)	--condition for the effect to take place
	e1:SetOperation(s.operation)	--actual effect
	c:RegisterEffect(e1)	--add the effect to this card

	--effect 2: Except the turn it was sent to GY, you can sp summon it from the GY if you control a "Stardust", "Synchron", or "Warrior" synchro monster
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))	--set description to tip 1 from the database
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)	--set the category to sp summon
	e2:SetType(EFFECT_TYPE_IGNITION)	--make it an ignition effect
    e2:SetRange(LOCATION_GRAVE)	--make it only activatable from GY
	e2:SetCountLimit(1,id+1)	--make it a hard one-per-turn
	e2:SetCondition(aux.exccon)	--apply "except the turn this card was sent to the GY" condition
	e2:SetTarget(s.target2)	--check for proper conditions to summon
	e2:SetOperation(s.operation2)	--actual effect
	c:RegisterEffect(e2)	--add the effect to this card
end
--effect 1: When used as synchro material, the monster cannot be destroyed by battle

--condition to check if it was used as sychro material.  Used code from c50793215 and modified it to fit naming conventions
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end

--function of effect.  Used code from c50793215 and modified it to fit the effect and naming conventions
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	--this card
	local rc=c:GetReasonCard()	--the card that was summoned
	local e1=Effect.CreateEffect(c)	--the effect to add to rc
	e1:SetDescription(aux.Stringid(110200202,0))	--Set as tip 0 from the database
	e1:SetType(EFFECT_TYPE_SINGLE)	--Only affects an individual card
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)	--Displays the description
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)	--Specifies effect
	e1:SetValue(1)	--value for the effect
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)	--specify reset conditions
	rc:RegisterEffect(e1,true)	--add the effect to rc

end



--effect 2: Except the turn it was sent to GY, you can sp summon it from the GY if you control a "Stardust", "Synchron", or "Warrior" synchro monster

--runs the checks to make sure the card can be special summoned and sets up for operation2
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

--actual function of the sp summon effect
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	--this card
	--used c94076521 as reference for remove from play redirect.

	--if summon was successful...
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e2=Effect.CreateEffect(c)	--create new effect for redirect
		e2:SetType(EFFECT_TYPE_SINGLE)	--only affects this card
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)	--can't be negated or otherwise stopped
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)	--send to another place when leaving field
		e2:SetValue(LOCATION_REMOVED)	--set redirect destination to banish zone
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)	--uses redirect resets
		c:RegisterEffect(e2, true)	--add effect to this card.  isForced set to true.
	end
	

end

--conditional to check if a card is face up, belongs to "Stardust", "Synchron", or "Warrior" archetype, and is a synchro monster
function s.spfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xa3) or c:IsSetCard(0x1017) or c:IsSetCard(0x66)) and c:IsType(TYPE_SYNCHRO)

end