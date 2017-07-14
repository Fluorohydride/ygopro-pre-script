--サブテラーマリスの妖魔
--Subterror Behemoth Apparition
--Script by nekrozar
function c100420001.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_FLIP),2,2)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c100420001.matcheck)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100420001,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,100420001)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c100420001.tgtg)
	e2:SetOperation(c100420001.tgop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100420001,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_FLIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100420001.thcon)
	e3:SetTarget(c100420001.thtg)
	e3:SetOperation(c100420001.thop)
	c:RegisterEffect(e3)
end
function c100420001.matfilter(c)
	return c:IsSetCard(0xed) and c:GetOriginalLevel()>=0
end
function c100420001.matcheck(e,c)
	local g=c:GetMaterial():Filter(c100420001.matfilter,nil)
	local atk=g:GetSum(Card.GetOriginalLevel)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk*100)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c100420001.tgfilter(c)
	return c:IsType(TYPE_FLIP) and c:IsAbleToGrave()
end
function c100420001.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp,zone)
end
function c100420001.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone()
	if chk==0 then return Duel.IsExistingMatchingCard(c100420001.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c100420001.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100420001.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100420001.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0
		and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local zone=e:GetHandler():GetLinkedZone()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c100420001.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
		if zone~=0 and sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE,zone)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c100420001.cfilter(c,g)
	return g:IsContains(c)
end
function c100420001.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c100420001.cfilter,1,nil,lg)
end
function c100420001.thfilter(c)
	return c:IsType(TYPE_FLIP) and c:IsAbleToHand()
end
function c100420001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100420001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100420001.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
