--竜輝巧－ファフμβ’
--
--Script by mercury233
function c101104043.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,1,2,nil,nil,99)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104043,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101104043)
	e1:SetCondition(c101104043.tgcon)
	e1:SetTarget(c101104043.tgtg)
	e1:SetOperation(c101104043.tgop)
	c:RegisterEffect(e1)
	--extra material
	if EFFECT_OVERLAY_RITUAL_MATERIAL==nil then
		EFFECT_OVERLAY_RITUAL_MATERIAL=364
		local _GetRitualMaterial=Duel.GetRitualMaterial
		local _ReleaseRitualMaterial=Duel.ReleaseRitualMaterial
		function Duel.GetRitualMaterial(tp)
			local g=_GetRitualMaterial(tp)
			local xg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,EFFECT_OVERLAY_RITUAL_MATERIAL)
			for xc in aux.Next(xg) do
				g:Merge(xc:GetOverlayGroup())
			end
			return g
		end
		function Duel.ReleaseRitualMaterial(mat)
			local xmat=mat:Filter(Card.IsLocation,nil,LOCATION_OVERLAY)
			mat:Sub(xmat)
			Duel.SendtoGrave(xmat,REASON_RITUAL+REASON_EFFECT+REASON_MATERIAL)
			_ReleaseRitualMaterial(mat)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_OVERLAY_RITUAL_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101104043,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101104043+100)
	e3:SetCondition(c101104043.discon)
	e3:SetCost(c101104043.discost)
	e3:SetTarget(c101104043.distg)
	e3:SetOperation(c101104043.disop)
	c:RegisterEffect(e3)
end
function c101104043.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c101104043.tgfilter(c)
	return c:IsSetCard(0x154) and c:IsAbleToGrave()
end
function c101104043.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104043.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101104043.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101104043.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c101104043.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsRace(RACE_MACHINE)
end
function c101104043.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
		and ep==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsExistingMatchingCard(c101104043.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101104043.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101104043.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101104043.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
