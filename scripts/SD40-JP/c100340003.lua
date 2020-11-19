--氷結界の依巫
--Vessel Miko of the Ice Barrier
--LUA by Kohana Sonogami
function c100340003.initial_effect(c)
	--Cannot Change a Battle Position
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c100340003.postg)
	e1:SetCondition(c100340003.poscon)
	c:RegisterEffect(e1)
	--Special Summon from a hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100340003,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,100340003)
	e2:SetCondition(c100340003.spcon)
	e2:SetTarget(c100340003.sptg)
	e2:SetOperation(c100340003.spop)
	c:RegisterEffect(e2)
	--Special Summon a Token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100340003,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,100340003+100)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c100340003.tkcon)
	e3:SetTarget(c100340003.tktg)
	e3:SetOperation(c100340003.tkop)
	c:RegisterEffect(e3)
end
function c100340003.posfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2f)
end
function c100340003.poscon(e)
	return Duel.IsExistingMatchingCard(c100340003.posfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c100340003.postg(e,c)
	return c:IsDefensePos()
end
function c100340003.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2f)
end
function c100340003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100340003.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100340003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100340003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c100340003.tkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2f)
end
function c100340003.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100340003.tkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100340003.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100340103,0,0x4011,0,0,1,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c100340003.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,100340103,0,0x4011,0,0,1,RACE_AQUA,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,100340103)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
