--シークレット・パスフレーズ
--
--Script by JustFish
function c100415020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100415020+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100415020.target)
	e1:SetOperation(c100415020.activate)
	c:RegisterEffect(e1)
end
function c100415020.thfilter(c)
	return c:IsSetCard(0x1254,0x2254) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c100415020.thfilter1(c)
	return c:IsSetCard(0x2254) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100415020.scchk(c,sc)
	return c:IsSetCard(sc) and c:IsFaceup()
end
function c100415020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(c100415020.thfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c100415020.thfilter1,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(c100415020.scchk,tp,LOCATION_MZONE,0,1,nil,0x252)
			and Duel.IsExistingMatchingCard(c100415020.scchk,tp,LOCATION_MZONE,0,1,nil,0x253)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100415020.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100415020.thfilter,tp,LOCATION_DECK,0,1,nil)
	if Duel.IsExistingMatchingCard(c100415020.scchk,tp,LOCATION_MZONE,0,1,nil,0x252)
		and Duel.IsExistingMatchingCard(c100415020.scchk,tp,LOCATION_MZONE,0,1,nil,0x253) then
		local eg=Duel.GetMatchingGroup(c100415020.thfilter1,tp,LOCATION_DECK,0,1,nil)
		g:Merge(eg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:Select(tp,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
