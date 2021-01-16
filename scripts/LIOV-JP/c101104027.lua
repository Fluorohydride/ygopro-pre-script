--ダークアイ・ナイトメア

--Scripted by mallu11
function c101104027.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101104027)
	e1:SetCost(c101104027.drcost)
	e1:SetTarget(c101104027.drtg)
	e1:SetOperation(c101104027.drop)
	c:RegisterEffect(e1)
end
function c101104027.drfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c101104027.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104027.drfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local ct=2
	if Duel.IsPlayerCanDraw(tp,2) then ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101104027.drfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
	e:SetLabel(Duel.Remove(g,POS_FACEUP,REASON_COST))
end
function c101104027.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local label=e:GetLabel()
	if label==1 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	elseif label==2 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif label==3 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	end
end
function c101104027.drop(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	if label==1 then
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		end
	elseif label==2 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif label==3 then
		if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
