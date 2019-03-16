--ウィッチクラフトゴーレム・アルル
--
--Script by mercury233
function c101009028.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101009028,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101009028)
	e1:SetCondition(c101009028.atkcon)
	e1:SetTarget(c101009028.target)
	e1:SetOperation(c101009028.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101009028,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101009028)
	e2:SetCondition(c101009028.tgcon)
	e2:SetTarget(c101009028.target)
	e2:SetOperation(c101009028.operation)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101009028,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c101009028.retcon)
	e3:SetTarget(c101009028.rettg)
	e3:SetOperation(c101009028.retop)
	c:RegisterEffect(e3)
end
function c101009028.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and at:IsFaceup() and at:IsRace(RACE_SPELLCASTER)
end
function c101009028.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c101009028.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c101009028.cfilter,1,nil)
end
function c101009028.thfilter(c,tp)
	return c:IsAbleToHand() and (c:IsControler(1-tp) and c:IsOnField()
		or c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x128) and c:IsType(TYPE_SPELL))
end
function c101009028.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101009028.thfilter(chkc,tp) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c101009028.thfilter,tp,LOCATION_GRAVE,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101009028.thfilter,tp,LOCATION_GRAVE,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101009028.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101009028.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c101009028.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101009028.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
