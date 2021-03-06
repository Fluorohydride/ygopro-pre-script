--溟界の昏闇－アレート

--Scripted by mallu11
function c100416006.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100416006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,100416006)
	e1:SetCost(c100416006.spcost)
	e1:SetTarget(c100416006.sptg)
	e1:SetOperation(c100416006.spop)
	c:RegisterEffect(e1)
	--return to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100416006,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100416006+100)
	e2:SetTarget(c100416006.rgtg)
	e2:SetOperation(c100416006.rgop)
	c:RegisterEffect(e2)
end
function c100416006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp)
	if chk==0 then return g:CheckSubGroup(aux.mzctcheckrel,1,1,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,aux.mzctcheckrel,false,1,1,tp)
	aux.UseExtraReleaseCount(rg,tp)
	Duel.Release(rg,REASON_COST)
end
function c100416006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100416006.thfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand(1-tp)
end
function c100416006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100416006.thfilter),tp,0,LOCATION_GRAVE,1,nil,tp)
		and Duel.SelectYesNo(1-tp,aux.Stringid(100416006,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(c100416006.thfilter),tp,0,LOCATION_GRAVE,1,1,nil,tp)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,g)
	end
end
function c100416006.rgfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end
function c100416006.fselect(g)
	return g:IsExists(Card.IsRace,1,nil,RACE_REPTILE)
end
function c100416006.rgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c100416006.rgfilter,tp,LOCATION_REMOVED,0,nil,e)
	if chk==0 then return g:CheckSubGroup(c100416006.fselect,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c100416006.fselect,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,2,0,0)
end
function c100416006.rgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end
