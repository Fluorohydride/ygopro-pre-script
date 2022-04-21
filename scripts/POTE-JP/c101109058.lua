--烙印の命数
--
--Script by Trishula9
function c101109058.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101109058,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101109058)
	e2:SetCondition(c101109058.tgcon)
	e2:SetTarget(c101109058.tgtg)
	e2:SetOperation(c101109058.tgop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,101109058+100)
	e3:SetCondition(c101109058.atkcon)
	e3:SetTarget(c101109058.atktg)
	e3:SetOperation(c101109058.atkop)
	c:RegisterEffect(e3)
end
function c101109058.tcfilter(c,tp,re,rp)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and re and re:IsActiveType(TYPE_SPELL) and rp==tp
end
function c101109058.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:FilterCount(c101109058.tcfilter,nil,tp,re,rp)==1
end
function c101109058.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0 or Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_EXTRA)
end
function c101109058.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if (#g1~=0 or #g2~=0) then
		local g=nil
		if #g1~=0 and (#g2==0 or Duel.SelectOption(tp,aux.Stringid(101109058,1),aux.Stringid(101109058,2))==0) then
			g=g1
		else
			g=g2
			Duel.ConfirmCards(tp,g)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c101109058.acfilter(c,tp,re,rp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and re and re:IsActiveType(TYPE_SPELL) and rp==tp
end
function c101109058.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:FilterCount(c101109058.acfilter,nil,tp,re,rp)==1
end
function c101109058.tgfilter(c,eg)
	return eg:IsContains(c)
end
function c101109058.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c101109058.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,eg) end
	Duel.SetTargetCard(eg)
end
function c101109058.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetBaseAttack())
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(c101109058.atlimit)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c101109058.atlimit(e,c)
	return not c:IsAttackPos() or c:IsControler(e:GetHandlerPlayer())
end
