--ベクター・スケア・デーモン
--Vector Square Archfiend
--Script by nekrozar
function c101003040.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101003040,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdogcon)
	e1:SetCost(c4709881.spcost)
	e1:SetTarget(c101003040.sptg)
	e1:SetOperation(c101003040.spop)
	c:RegisterEffect(e1)
end
function c101003040.cfilter(c,tp,g,zone1,zone2)
	return g:IsContains(c) and (Duel.CheckLocation(c:GetControler(),LOCATION_MZONE,c:GetSequence(),true)
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone2)>0)
end
function c101003040.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local zone=bit.rshift(c:GetLinkedZone(),16)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101003040.cfilter,1,nil,tp,lg,zone) end
	local g=Duel.SelectReleaseGroup(tp,c101003040.cfilter,1,1,nil,tp,lg,zone)
	Duel.Release(g,REASON_COST)
end
function c101003040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local zone1=bit.band(c:GetLinkedZone(),0x1f)
	local zone2=bit.rshift(c:GetLinkedZone(),16)
	if chk==0 then return c:GetLinkedZone()~=0
		and (bc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone1,true))
		or (bc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone2)) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,0)
end
function c101003040.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:GetLinkedZone()~=0 and tc:IsRelateToEffect(e) then
		local zone1=bit.band(c:GetLinkedZone(),0x1f)
		local zone2=bit.rshift(c:GetLinkedZone(),16)
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone1)
			and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone2) or Duel.SelectYesNo(tp,aux.Stringid(101003040,1))) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone1)
		else
			if Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP,zone2)~=0
				and c:IsRelateToBattle() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EXTRA_ATTACK)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
				c:RegisterEffect(e1)
			end
		end
	end
end
