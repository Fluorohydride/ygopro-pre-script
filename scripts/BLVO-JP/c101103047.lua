--神樹獣ハイペリュトン
--Divine Treebeast High Peryton
--Script by: XGlitchy30
function c101103047.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2)
	c:EnableReviveLimit()
	--attach overlay
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103047,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101103047)
	e1:SetCondition(c101103047.ovcon)
	e1:SetTarget(c101103047.ovtg)
	e1:SetOperation(c101103047.ovop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103047,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101103147)
	e2:SetCondition(c101103047.negcon)
	e2:SetTarget(c101103047.negtg)
	e2:SetOperation(c101103047.negop)
	c:RegisterEffect(e2)
end
function c101103047.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and rp==tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c101103047.ovfilter(c,typ)
	return c:IsType(typ) and c:IsCanOverlay()
end
function c101103047.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local typ=bit.band(re:GetActiveType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101103047.ovfilter(chkc,typ) end
	if chk==0 then return Duel.IsExistingTarget(c101103047.ovfilter,tp,LOCATION_GRAVE,0,1,nil,typ) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(c101103047.ovfilter),tp,LOCATION_GRAVE,0,1,1,nil,typ)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c101103047.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c101103047.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c101103047.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local typ=bit.band(re:GetActiveType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		return e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,typ)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101103047.negop(e,tp,eg,ep,ev,re,r,rp)
	local typ=bit.band(re:GetActiveType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	local og=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,typ)
	if og:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=og:Select(tp,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
