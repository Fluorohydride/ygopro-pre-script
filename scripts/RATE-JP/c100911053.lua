--十二獣ドランシア
--Juunishishi Drancia
--Script by nekrozar
function c100911053.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,4,c100911053.ovfilter,aux.Stringid(100911053,0),4,c100911053.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100911053.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c100911053.defval)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100911053,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c100911053.descost)
	e3:SetTarget(c100911053.destg)
	e3:SetOperation(c100911053.desop)
	c:RegisterEffect(e3)
end
function c100911053.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1f2) and not c:IsCode(100911053)
end
function c100911053.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100911053)==0 end
	Duel.RegisterFlagEffect(tp,100911053,RESET_PHASE+PHASE_END,0,1)
end
function c100911053.atkfilter(c)
	return c:IsSetCard(0x1f2) and c:GetAttack()>=0
end
function c100911053.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100911053.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c100911053.deffilter(c)
	return c:IsSetCard(0x1f2) and c:GetDefense()>=0
end
function c100911053.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100911053.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c100911053.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100911053.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100911053.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
