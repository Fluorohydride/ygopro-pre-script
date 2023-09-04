--秘旋谍-双面风
function c100209283.initial_effect(c)
	--special summon & show topdeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100209283)
	e1:SetCondition(c100209283.spcon)
	e1:SetTarget(c100209283.sptg)
	e1:SetOperation(c100209283.spop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xee))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--direct attack
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
end
function c100209283.cfilter(c)
	return c:IsSetCard(0xee) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c100209283.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100209283.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c100209283.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,POS_FACEUP_DEFENSE,1-tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100209283.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(c100209283.fuslimit)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3,true)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4:SetValue(1)
		c:RegisterEffect(e4,true)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e5,true)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		c:RegisterEffect(e6,true)
	end
end
function c100209283.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
