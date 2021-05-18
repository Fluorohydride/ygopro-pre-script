--キ－Ai－
--scripted by XyleN
function c100278041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100278041+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100278041.target)
	e1:SetOperation(c100278041.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EFFECT_DESTROY_REPLACE) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c100278041.reptg)
	e2:SetValue(c100278041.repval)
	e2:SetOperation(c100278041.repop)
	c:RegisterEffect(e2) 
	--indestructable by battle
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(100278041,0)) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_REMOVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetOperation(c100278041.indesop)
	c:RegisterEffect(e3)
end
function c100278041.filter(c,e,tp)
	return c:IsSetCard(0x135) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100278041.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100278041.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100278041.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100278041.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100278041.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100278041.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x135) and c:IsAttackAbove(2300)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c100278041.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c100278041.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c100278041.repval(e,c)
	return c100278041.repfilter(c,e:GetHandlerPlayer())
end
function c100278041.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c100278041.indesop(e,tp,eg,ep,ev,re,r,rp)
	--unable to destroyed by battle
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c100278041.indestg)
	e1:SetValue(1)
	e1:SetReset(EVENT_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100278041.indestg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x135) and c:IsAttackAbove(2300)
end
