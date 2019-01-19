--静冠の呪眼
--
--Scripted by Maru
function c100412036.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100412036+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100412036.target)
	e1:SetOperation(c100412036.activate)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100412036.rmtg)
	e2:SetOperation(c100412036.rmop)
	c:RegisterEffect(e2)
	--recycle
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c100412036.tgcon)
	e3:SetTarget(c100412036.tgtg)
	e3:SetOperation(c100412036.tgop)
	c:RegisterEffect(e3)
end
function c100412036.costfilter(c)
	return c:IsSetCard(0x226) and c:IsAbleToRemoveAsCost()
end
function c100412036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c100412036.costfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(100412036,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c100412036.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetLabel(0)
	end
end
function c100412036.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():IsRelateToEffect(e) and e:GetLabel()==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c100412036.check(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x226) and c:GetEquipGroup() and c:GetEquipGroup():IsExists(Card.IsCode,1,nil,100412032)
end
function c100412036.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then return d~=nil and c100412036.check(a,tp) end
	e:SetLabelObject(d)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,d,1,0,0)
end
function c100412036.rmop(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabelObject()
	if e:GetHandler():IsRelateToEffect(e) and d:IsRelateToBattle() then
		Duel.Remove(d,POS_FACEUP,REASON_EFFECT)
	end
end
function c100412036.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_SZONE)
end
function c100412036.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x226)
end
function c100412036.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c100412036.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100412036.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100412036,1))
	local g=Duel.SelectTarget(tp,c100412036.filter,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c100412036.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end
