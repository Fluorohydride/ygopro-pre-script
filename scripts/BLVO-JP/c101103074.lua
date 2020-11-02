--战华史略-大丈夫之义
function c101103074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103074,0))
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101103074)
	e2:SetCondition(c101103074.tkcon)
	e2:SetTarget(c101103074.tktg)
	e2:SetOperation(c101103074.tkop)
	c:RegisterEffect(e2)   
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c101103074.reptg)
	e3:SetValue(c101103074.repval)
	e3:SetOperation(c101103074.repop)
	c:RegisterEffect(e3) 
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101103074,1))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1,101103174)
	e4:SetCondition(c101103074.negcon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c101103074.negtg)
	e4:SetOperation(c101103074.negop)
	c:RegisterEffect(e4)
end
function c101103074.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c101103074.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101103074.cfilter,1,nil,tp)
end
function c101103074.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101103174,0x137,0x4011,500,500,1,RACE_BEASTWARRIOR,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101103074.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,101103174,0x137,0x4011,500,500,1,RACE_BEASTWARRIOR,ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp,101103174)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101103074.repfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x137) and not c:IsReason(REASON_REPLACE)
end
function c101103074.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c101103074.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101103074.repval(e,c)
	return c101103074.repfilter(c,e:GetHandlerPlayer())
end
function c101103074.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c101103074.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x137)
end
function c101103074.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c101103074.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c101103074.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c101103074.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end