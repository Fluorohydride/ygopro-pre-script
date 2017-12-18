--剛鬼ジェット・オーガ
--Gouki Jet Ogre
--Script by nekrozar
function c100225011.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xfc),2,2)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100225011,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c100225011.postg)
	e1:SetOperation(c100225011.posop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100225011,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100225011)
	e2:SetCondition(c100225011.atkcon)
	e2:SetTarget(c100225011.atktg)
	e2:SetOperation(c100225011.atkop)
	c:RegisterEffect(e2)
end
function c100225011.desfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xfc)
		and Duel.IsExistingMatchingCard(c100225011.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c100225011.posfilter(c)
	return c:IsDefensePos() or c:IsFacedown()
end
function c100225011.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c100225011.desfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100225011.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100225011.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100225011.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c100225011.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if g:GetCount()==0 then return end
		Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	end
end
function c100225011.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c100225011.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xfc)
end
function c100225011.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100225011.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c100225011.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100225011.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
