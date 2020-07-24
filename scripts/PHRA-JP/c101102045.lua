--天霆號アーゼウス

--Scripted by mallu11
function c101102045.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2,c101102045.ovfilter,aux.Stringid(101102045,0),2,c101102045.xyzop)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101102045,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c101102045.tgcost)
	e1:SetTarget(c101102045.tgtg)
	e1:SetOperation(c101102045.tgop)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101102045,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101102045.ovcon)
	e2:SetTarget(c101102045.ovtg)
	e2:SetOperation(c101102045.ovop)
	c:RegisterEffect(e2)
	if not c101102045.global_check then
		c101102045.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c101102045.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101102045.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c101102045.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101102045)>0 and Duel.GetFlagEffect(tp,101102145)==0 end
	Duel.RegisterFlagEffect(tp,101102145,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c101102045.check(c)
	return c and c:IsType(TYPE_XYZ)
end
function c101102045.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c101102045.check(Duel.GetAttacker()) or c101102045.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,101102045,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,101102045,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101102045.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c101102045.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function c101102045.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c101102045.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function c101102045.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101102045.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c101102045.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function c101102045.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and not c:IsImmuneToEffect(e) then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(c,tc)
		end
	end
end
