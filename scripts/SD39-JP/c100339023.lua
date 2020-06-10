--憑依覚醒－大稲荷火
--
--Script by JustFish
function c100339023.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c100339023.spcon)
	e1:SetOperation(c100339023.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100339023,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,100339023)
	e2:SetCondition(c100339023.condition)
	e2:SetTarget(c100339023.dmtg)
	e2:SetOperation(c100339023.dmop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100339023,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,100339023+100)
	e3:SetCondition(c100339023.thcon)
	e3:SetTarget(c100339023.thtg)
	e3:SetOperation(c100339023.thop)
	c:RegisterEffect(e3)
end
function c100339023.spfilter1(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c100339023.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c100339023.spfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGraveAsCost() and c:IsLevelBelow(4)
end
function c100339023.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c100339023.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c100339023.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c100339023.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c100339023.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c100339023.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c100339023.dmfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
end
function c100339023.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100339023.dmfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c100339023.dmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100339023,2))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100339023.dmfilter),tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and tc:IsFaceup() and tc:GetBaseAttack()>0 then
		Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
	end
end
function c100339023.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c100339023.thfilter(c)
	return ((c:IsSetCard(0xc0) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or c:IsSetCard(0x624c)) and c:IsAbleToHand()
end
function c100339023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100339023.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100339023.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100339023.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
