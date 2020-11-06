--古代戦士佐賀 - 男の名誉
--LUA by Kohana♡
function c82255872.initial_effect(c)
	--Activation
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
	--Destroy Replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82255872,0))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,82255872)
	e1:SetTarget(c82255872.reptg)
	e1:SetValue(c82255872.repval)
	e1:SetOperation(c82255872.repop)
	c:RegisterEffect(e1)
	--Token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82255872,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,82255873)
	e2:SetCondition(c82255872.tkcon)
	e2:SetTarget(c82255872.tktg)
	e2:SetOperation(c82255872.tkop)
	c:RegisterEffect(e2)
	--Negate that targets to "Ancient Warrior"
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82255872,2))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,82255874)
	e3:SetCondition(c82255872.negcon)
	e3:SetCost(c82255872.aux.bfgcost)
	e3:SetTarget(c82255872.negtg)
	e3:SetOperation(c82255872.negop)
	c:RegisterEffect(e3)
end
--Can only be activated during your opponent's turn
function c82255872.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
--Choose which zone you want to Summon a Token
function c82255872.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
--Activation
local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,82255873,0,0x4011,500,500,1,RACE_BEASTWARRIOR,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,82255873)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
--Check for "Ancient Warrior"
function c82255872.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x137) and c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
--Replace to this card
function c82255872.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c82255872.repfilter,1,e:GetHandler(),tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
--Replace Value
function c82255872.repval(e,c)
	return c82255872.repfilter(c,e:GetHandlerPlayer())
end
--Activation
function c82255872.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
--Check for "Ancient Warrior"
function c82255872.negfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x137)
end
--Activation Condition that targets to "Ancient Warrior"
function c82255872.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not aux.IsDualState(e) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsExists(c82255872.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
--Can only be negated when that monster is activated
function c82255872.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
--Activation
function c82255872.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
