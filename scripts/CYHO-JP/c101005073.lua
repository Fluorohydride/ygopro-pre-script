--サイバネティック・オーバーフロー
--Cybernetic Overflow
--Scripted by Eerie Code
function c101005073.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101005073)
	e1:SetTarget(c101005073.target)
	e1:SetOperation(c101005073.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101005073+100)
	e2:SetCondition(c101005073.thcon)
	e2:SetTarget(c101005073.thtg)
	e2:SetOperation(c101005073.thop)
	c:RegisterEffect(e2)
end
function c101005073.rmfilter(c)
	return c:IsCode(70095154) and c:IsLevelAbove(1) and c:IsAbleToRemove()
end
function c101005073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101005073.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c101005073.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLevel)==sg:GetCount()
end
function c101005073.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local g=Duel.GetMatchingGroup(c101005073.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	if dg:GetCount()==0 or g:GetCount()==0 then return end
	local rg=aux.SelectUnselectGroup(g,e,tp,1,dg:GetCount(),c101005073.rescon,1,tp,HINTMSG_REMOVE)
	local rc=Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	if rc>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=dg:Select(tp,rc,rc,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c101005073.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and r&REASON_EFFECT~=0
end
function c101005073.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsSetCard(0x94) or c:IsSetCard(0x93)) and c:IsAbleToHand()
end
function c101005073.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101005073.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101005073.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101005073.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
