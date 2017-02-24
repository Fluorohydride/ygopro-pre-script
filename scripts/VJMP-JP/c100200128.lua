--EMカード・ガードナー
--Performapal Card Gardna
--Script by dest
function c100200128.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--other defup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200128,0))
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c100200128.target)
	e1:SetOperation(c100200128.operation)
	c:RegisterEffect(e1)
	--own defup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c100200128.defval)
	c:RegisterEffect(e2)
end
function c100200128.filter(c,def)
	return c:IsPosition(POS_FACEUP_DEFENSE) and c:GetDefense()~=def
end
function c100200128.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP_DEFENSE)
	local def=g:GetSum(Card.GetBaseDefense)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100200128.filter(chkc,def) end
	if chk==0 then return Duel.IsExistingTarget(c100200128.filter,tp,LOCATION_MZONE,0,1,nil,def) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100200128.filter,tp,LOCATION_MZONE,0,1,1,nil,def)
end
function c100200128.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP_DEFENSE)
		local def=g:GetSum(Card.GetBaseDefense)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(def)
		tc:RegisterEffect(e1)
	end
end
function c100200128.deffilter(c)
	return c:GetBaseDefense()>=0 and c:IsSetCard(0x9f)
end
function c100200128.defval(e,c)
	local g=Duel.GetMatchingGroup(c100200128.deffilter,c:GetControler(),LOCATION_MZONE,0,c)
	return g:GetSum(Card.GetBaseDefense)
end
