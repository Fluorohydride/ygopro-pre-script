--DDゴースト
--D/D Ghost
--Scripted by Eerie Code
function c100912015.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100912015,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100912015.tgtg)
	e1:SetOperation(c100912015.tgop)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100912015,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c100912015.rtgtg)
	e2:SetOperation(c100912015.rtgop)
	c:RegisterEffect(e2)
end
function c100912015.tgfilter1(c,tp)
	return ((c:IsSetCard(0xaf) and c:IsType(TYPE_MONSTER) and not c:IsCode(100912015)) or c:IsSetCard(0xae))
		and Duel.IsExistingMatchingCard(c100912015.tgfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c100912015.tgfilter2(c,cd)
	return c:IsCode(cd) and c:IsAbleToGrave()
end
function c100912015.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsCode(e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c100912015.tgfilter1,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100912015.tgfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100912015.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c100912015.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c100912015.rtgfilter(c)
	return c:IsFaceup() and ((c:IsSetCard(0xaf) and c:IsType(TYPE_MONSTER) and not c:IsCode(100912015)) or c:IsSetCard(0xae))
end
function c100912015.rtgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c100912015.rtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100912015.rtgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100912015.rtgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c100912015.rtgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
