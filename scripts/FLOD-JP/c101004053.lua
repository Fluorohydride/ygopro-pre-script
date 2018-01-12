--サイバーサル・サイクロン
--Cybersal Cyclone
--scripted by Larry126
function c101004053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101004053.target)
	e1:SetOperation(c101004053.activate)
	c:RegisterEffect(e1)
end
function c101004053.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
		and Duel.IsExistingMatchingCard(c101004053.rmfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetLink())
end
function c101004053.rmfilter(c,link)
	return c:IsType(TYPE_MONSTER) and c:IsLink(link) and c:IsAbleToRemove()
end
function c101004053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c101004053.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101004053.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101004053.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c101004053.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroVallerFilter(c101004053.rmfilter),tp,LOCATION_GRAVE,0,1,1,nil,tc:GetLink())
	local rc=g:GetFirst()
	if rc and Duel.Remove(rc,0,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_REMOVED)
		and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_SZONE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101004053,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
