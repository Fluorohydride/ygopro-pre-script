--フリント・クラッガー
--Flint Cragger
--LUA by Kohana Sonogami
--
function c100273005.initial_effect(c)
	--Send 1 "Fossil" from your Extra Deck to the GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100273005,0))
	e1:SetCategory(CATEGORY_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100273005)
	e1:SetTarget(c100273005.tgtg)
	e1:SetOperation(c100273005.tgop)
	c:RegisterEffect(e1)
	--Inflict 500 then return 1 "Fossil" into the GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100273005,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100273005+100)
	e2:SetCondition(c100273005.damcon)
	e2:SetTarget(c100273005.damtg)
	e2:SetOperation(c100273005.damop)
	c:RegisterEffect(e2)
end
function c100273005.tgfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x149) and c:IsAbleToGrave()
end
function c100273005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c100273005.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c100273005.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c100273005.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c100273005.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c100273005.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c100273005.tgfilter1(c)
	return (aux.IsCodeListed(c,59419719) or c:IsCode(59419719)) and c:IsAbleToDeck()
end
function c100273005.cfilter(c)
	return c:IsCode(59419719)
end
function c100273005.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT) and Duel.IsExistingMatchingCard(c100273005.cfilter,tp,LOCATION_GRAVE,0,1,nil)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.GetMatchingGroup(c100273005.tgfilter1,tp,LOCATION_REMOVED,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100273005,2)) then
			Duel.BreakEffect()
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		end
	end
end
