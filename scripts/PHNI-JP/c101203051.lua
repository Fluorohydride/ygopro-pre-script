--威风妖怪·鵺
--lua by Gim J.Blocks
function c101203051.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_PENDULUM),2,2,c101203051.lcheck)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101203051,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101203051)
	e1:SetCondition(c101203051.thcon)
	e1:SetTarget(c101203051.thtg)
	e1:SetOperation(c101203051.thop)
	c:RegisterEffect(e1)
end
function c101203051.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xd0)
end
function c101203051.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101203051.thfilter(c)
	return c:IsSetCard(0xd0) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand()
end
function c101203051.tefilter(c)
	return c:IsSetCard(0xd0) and c:IsType(TYPE_PENDULUM)
end
function c101203051.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101203051.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c101203051.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101203051.thfilter,tp,LOCATION_EXTRA,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		local cg=Duel.GetMatchingGroup(c101203051.tefilter,tp,LOCATION_DECK,0,nil)
		if #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(101203051,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101203051,2))
			local hg=cg:SelectSubGroup(tp,aux.dncheck,false,1,2)
			if hg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoExtraP(hg,nil,REASON_EFFECT)
			end
		end	
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101203051.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101203051.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xd0,0xc7) and c:IsLocation(LOCATION_EXTRA)
end