--剣の王 フローディ

--Scripted by nekrozar
function c100413028.initial_effect(c)
	c:SetUniqueOnField(1,0,100413028)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100413028,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100413028)
	e1:SetCost(c100413028.descost)
	e1:SetTarget(c100413028.destg)
	e1:SetOperation(c100413028.desop)
	c:RegisterEffect(e1)
end
function c100413028.costfilter(c,tp)
	return (c:IsSetCard(0x134) or c:IsRace(RACE_WARRIOR))
		and Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c100413028.fselect(g,tp)
	if Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,g:GetCount(),g) then
		Duel.SetSelectedCard(g)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c100413028.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100413028.costfilter,1,nil,tp) end
	local rg=Duel.GetReleaseGroup(tp):Filter(c100413028.costfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c100413028.fselect,false,1,99,tp)
	local ct=Duel.Release(sg,REASON_COST)
	e:SetLabel(ct)
end
function c100413028.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c100413028.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(tg,REASON_EFFECT)==0 then return end
	local ct=Duel.GetOperatedGroup():FilterCount(aux.FilterEqualFunction(Card.GetPreviousControler,1-tp),nil)
	if ct>0 and Duel.IsPlayerCanDraw(1-tp,ct) and Duel.SelectYesNo(1-tp,aux.Stringid(100413028,1)) then
		Duel.BreakEffect()
		Duel.Draw(1-tp,ct,REASON_EFFECT)
	end
end
