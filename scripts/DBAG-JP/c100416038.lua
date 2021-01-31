--ベアルクティ・ビッグディッパー
--Bearcti Big Dipper
--Scripted by Kohana Sonogami
function c100416038.initial_effect(c)
	c:EnableCounterPermit(0x60)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(100416038)
	e2:SetCountLimit(1)
	e2:SetTarget(c100416038.repfilter)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c100416038.ctop)
	c:RegisterEffect(e3)
	--take control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100416038,0))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c100416038.tkccon)
	e4:SetCost(c100416038.tkccost)
	e4:SetTarget(c100416038.tkctg)
	e4:SetOperation(c100416038.tkcop)
	c:RegisterEffect(e4)
end
function c100416038.repfilter(e,c)
	return c:IsLevelAbove(7) and c:IsSetCard(0x261)
end
function c100416038.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x60,1)
end
function c100416038.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x261) and c:IsType(TYPE_SYNCHRO)
end
function c100416038.tkccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100416038.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c100416038.tkccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x60,7,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x60,e:GetHandler():GetCounter(0x60),REASON_COST)
end
function c100416038.tkctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c100416038.tkcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
