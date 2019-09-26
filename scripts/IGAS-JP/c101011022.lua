--虚の王 ウートガルザ

--Scripted by mallu11
function c101011022.initial_effect(c)
	c:SetUniqueOnField(1,0,101011022)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101011022)
	e1:SetCost(c101011022.rmcost)
	e1:SetTarget(c101011022.rmtg)
	e1:SetOperation(c101011022.rmop)
	c:RegisterEffect(e1)
end
function c101011022.cfilter(c,tp)
	return c:IsSetCard(0x134) or c:IsRace(RACE_ROCK)
end
function c101011022.fselect(c,tp,rg,sg)
	sg:AddCard(c)
	if sg:GetCount()<2 then
		res=rg:IsExists(c101011022.fselect,1,sg,tp,rg,sg)
	else
		res=c101011022.fgoal(tp,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c101011022.fgoal(tp,sg)
	if sg:GetCount()>0 and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,sg) then
		Duel.SetSelectedCard(sg)
	return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c101011022.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp):Filter(c101011022.cfilter,nil,tp)
	local g=Group.CreateGroup()
	if chk==0 then return rg:IsExists(c101011022.fselect,1,nil,tp,rg,g) end
	while g:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=rg:FilterSelect(tp,c101011022.fselect,1,1,g,tp,rg,g)
		g:Merge(sg)
	end
	Duel.Release(g,REASON_COST)
end
function c101011022.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,1,0,0)
end
function c101011022.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
