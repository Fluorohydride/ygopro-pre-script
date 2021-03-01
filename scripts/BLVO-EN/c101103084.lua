--Materiactor Gigaboros

--Scripted by mallu11
function c101103084.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,3,2,nil,nil,99)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101103084.adval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101103084,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101103084)
	e3:SetCost(c101103084.matcost)
	e3:SetTarget(c101103084.mattg)
	e3:SetOperation(c101103084.matop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101103084,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetCountLimit(1,101103084+100)
	e4:SetCondition(c101103084.thcon)
	e4:SetTarget(c101103084.thtg)
	e4:SetOperation(c101103084.thop)
	c:RegisterEffect(e4)
end
function c101103084.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*500
end
function c101103084.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101103084.matfilter(c)
	return c:IsSetCard(0x160) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c101103084.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c101103084.matfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c101103084.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c101103084.matfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end
function c101103084.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==1-tp
		and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c101103084.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup()
	if chk==0 then return g:IsExists(Card.IsAbleToHand,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end
function c101103084.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=c:GetOverlayGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
		end
	end
end
